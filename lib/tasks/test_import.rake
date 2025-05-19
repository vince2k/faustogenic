# lib/tasks/test_ciqual_import.rake
require 'nokogiri'

namespace :ciqual do
  desc "Test import des valeurs nutritionnelles pour quelques aliments Ciqual"
  task test_import: :environment do
    alim_file = Rails.root.join('lib', 'data', 'alim_2020_07_07.xml')
    compo_file = Rails.root.join('lib', 'data', 'compo_2020_07_07.xml')

    # Vérifier l'existence des fichiers
    [alim_file, compo_file].each do |file|
      unless File.exist?(file)
        puts "Erreur : Le fichier #{file} n'existe pas !"
        return
      end
    end

    begin
      # Fonction pour nettoyer les chaînes
      # def clean_string(str)
      #   return str if str.nil? || str.empty?
      #   str.gsub(/[\r\n]+/, ' ').gsub(/\s+/, ' ').strip
      # end

      # Aliments à tester
      target_codes = %w[6581 12801]

      # 1. Parser les aliments
      puts "Étape 1 : Parsage des aliments..."
      alim_doc = Nokogiri::XML(File.read(alim_file))
      puts "  Nœuds trouvés : #{alim_doc.xpath('//*').map(&:name).uniq}"
      puts "  Nombre de nœuds ALIM : #{alim_doc.xpath('//ALIM').count}"
      foods = {}
      food_count = 0
      skipped_foods = 0
      alim_doc.xpath('//ALIM').each do |alim|
        code = alim.at_xpath('alim_code')&.text
        raw_name = alim.at_xpath('alim_nom_fr')&.text
        puts "  Code brut trouvé : #{code.inspect}, nom brut : #{raw_name.inspect}"
        next unless code

        code = code.strip
        name = raw_name
        puts "  Aliment traité : ciqual_code=#{code}, name=#{name.inspect}" if target_codes.include?(code)
        unless target_codes.include?(code)
          skipped_foods += 1
          next
        end

        unless name
          puts "  Sauté aliment : code=#{code}, name=#{name}"
          skipped_foods += 1
          next
        end

        foods[code] = {
          name: name,
          food_group: nil
        }
        food_count += 1
      end
      puts "  Aliments dans foods : #{foods.keys.inspect}"
      puts "  => #{food_count} aliments parsés, #{skipped_foods} sautés."

      # 2. Parser les compositions
      puts "Étape 2 : Parsage des compositions..."
      compo_doc = Nokogiri::XML(File.read(compo_file))
      puts "  Nœuds trouvés : #{compo_doc.xpath('//*').map(&:name).uniq}"
      puts "  Nombre de nœuds COMPO : #{compo_doc.xpath('//COMPO').count}"
      nutrient_count = 0
      skipped_nutrients = 0
      compo_doc.xpath('//COMPO').each do |compo|
        alim_code = compo.at_xpath('alim_code')&.text
        puts "  COMPO alim_code brut : #{alim_code.inspect}"
        next unless alim_code
        alim_code = alim_code.strip
        puts "  COMPO alim_code nettoyé : #{alim_code.inspect}"
        unless foods[alim_code]
          puts "  Alim_code #{alim_code} non trouvé dans foods"
          next
        end

        nutrient_code = compo.at_xpath('const_code')&.text
        value = compo.at_xpath('teneur')&.text
        source_code = compo.at_xpath('source_code')&.text
        unless nutrient_code && value
          puts "  Sauté nutriment : alim_code=#{alim_code}, nutrient_code=#{nutrient_code}, value=#{value}, source_code=#{source_code}"
          skipped_nutrients += 1
          next
        end

        # Débogage : afficher la valeur brute
        puts "  Nutriment trouvé : alim_code=#{alim_code}, const_code=#{nutrient_code}, teneur=#{value.inspect}, source_code=#{source_code}" if target_codes.include?(alim_code)
        if target_codes.include?(alim_code) && %w[328 25000 40000 31000 32000 34100].include?(nutrient_code)
          puts "  Nutriment brut pour alim_code #{alim_code} : #{nutrient_code}=#{value.inspect}, source_code=#{source_code}"
        end

        # Gérer les valeurs spéciales
        if value == '-' || value == 'traces'
          value = 0.0
        elsif value.start_with?('<')
          value = 0.0
        else
          value = value.to_f
        end

        foods[alim_code][nutrient_code] = value
        nutrient_count += 1
      end
      puts "  => #{nutrient_count} valeurs de nutriments parsées, #{skipped_nutrients} sautés."

      # 3. Importer dans la base
      puts "Étape 3 : Importation dans la base..."
      ActiveRecord::Base.transaction do
        imported_count = 0
        skipped_ingredients = 0
        foods.each do |code, data|
          ingredient = Ingredient.find_or_initialize_by(ciqual_code: code, source: 'Ciqual')
          ingredient.assign_attributes(
            name: data[:name],
            energy_kcal: data['328'] || 0.0,
            proteins: data['25000'] || 0.0,
            fats: data['40000'] || 0.0,
            carbs: data['31000'] || 0.0,
            sugars: data['32000'] || 0.0,
            fibers: data['34100'] || 0.0
          )
          begin
            ingredient.save!
            imported_count += 1
            puts "  Ingrédient importé : ciqual_code=#{code}, name=#{data[:name]}, energy_kcal=#{data['328'] || 0.0}, proteins=#{data['25000'] || 0.0}, fats=#{data['40000'] || 0.0}"
          rescue ActiveRecord::RecordInvalid => e
            puts "Erreur pour l'aliment #{code} (#{data[:name]}): #{e.message}"
            skipped_ingredients += 1
          end
        end
        puts "  => #{imported_count} ingrédients importés, #{skipped_ingredients} sautés."
      end

      puts "Test d'importation terminé !"
    rescue StandardError => e
      puts "Erreur générale : #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
end
