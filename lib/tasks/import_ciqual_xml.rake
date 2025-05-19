# lib/tasks/ciqual_import.rake
require 'nokogiri'
require 'bigdecimal'

namespace :ciqual do
  desc "Import des données Ciqual pour tous les aliments"
  task import_xml: :environment do
    alim_file = Rails.root.join('lib', 'data', 'alim_2020_07_07_utf8.xml')
    compo_file = Rails.root.join('lib', 'data', 'compo_2020_07_07_utf8.xml')
    group_file = Rails.root.join('lib', 'data', 'alim_grp_2020_07_07_utf8.xml')

    # Vérifier l'existence des fichiers
    [alim_file, compo_file, group_file].each do |file|
      unless File.exist?(file)
        puts "Erreur : Le fichier #{file} n'existe pas !"
        return
      end
    end

    begin
      # Fonction pour nettoyer les chaînes
      def clean_string(str)
        return str if str.nil? || str.empty?
        str.gsub(/[\r\n]+/, ' ').gsub(/\s+/, ' ').strip
      end

      # 1. Importer les groupes d'aliments
      puts "Étape 1 : Importation des groupes d'aliments..."
      group_doc = Nokogiri::XML(File.read(group_file))
      puts "  Nœuds trouvés : #{group_doc.xpath('//*').map(&:name).uniq}"
      groups = {}
      group_count = 0
      skipped_groups = 0
      group_doc.xpath('//ALIM_GRP').each do |grp|
        code = grp.at_xpath('alim_grp_code')&.text&.strip
        name = clean_string(grp.at_xpath('alim_grp_nom_fr')&.text || '')
        unless code && name
          puts "  Sauté groupe : code=#{code}, name=#{name}"
          skipped_groups += 1
          next
        end

        group = FoodGroup.find_or_create_by!(ciqual_group_code: code) do |g|
          g.name = name
          parent_code = grp.at_xpath('alim_ssgrp_code')&.text&.strip
          g.parent = parent_code ? FoodGroup.find_by(ciqual_group_code: parent_code) : nil
        end
        groups[code] = group
        group_count += 1
      end
      puts "  => #{group_count} groupes importés, #{skipped_groups} sautés."

      # 2. Parser les aliments
      puts "Étape 2 : Parsage des aliments..."
      alim_doc = Nokogiri::XML(File.read(alim_file))
      puts "  Nœuds trouvés : #{alim_doc.xpath('//*').map(&:name).uniq}"
      foods = {}
      food_count = 0
      skipped_foods = 0
      alim_doc.xpath('//ALIM').each do |alim|
        code = alim.at_xpath('alim_code')&.text&.strip
        name = clean_string(alim.at_xpath('alim_nom_fr')&.text || '')
        group_code = alim.at_xpath('alim_grp_code')&.text&.strip
        unless code && name
          puts "  Sauté aliment : code=#{code}, name=#{name}"
          skipped_foods += 1
          next
        end

        unless groups[group_code]
          puts "  Groupe manquant pour aliment : ciqual_code=#{code}, group_code=#{group_code}"
          skipped_foods += 1
          next
        end

        foods[code] = {
          name: name,
          food_group: groups[group_code],
          nutrients: {}
        }
        food_count += 1
      end
      puts "  Aliments dans foods : #{foods.keys.count}"
      puts "  => #{food_count} aliments parsés, #{skipped_foods} sautés."

      # 3. Parser les compositions
      puts "Étape 3 : Parsage des compositions..."
      compo_content = File.read(compo_file, encoding: 'ISO-8859-1').encode('UTF-8')
      compo_doc = Nokogiri::XML(compo_content)
      puts "  Nœuds trouvés : #{compo_doc.xpath('//*').map(&:name).uniq}"
      puts "  Nombre de nœuds COMPO : #{compo_doc.xpath('//COMPO').count}"
      nutrient_count = 0
      skipped_nutrients = 0
      all_alim_codes = []
      compo_doc.xpath('//COMPO').each do |compo|
        alim_code_raw = compo.at_xpath('alim_code')&.text
        alim_code = alim_code_raw&.strip
        all_alim_codes << alim_code
        next unless foods[alim_code]

        nutrient_code_raw = compo.at_xpath('const_code')&.text
        nutrient_code = nutrient_code_raw&.strip
        value = compo.at_xpath('teneur')&.text&.strip
        source_code = compo.at_xpath('source_code')&.text
        unless nutrient_code && value
          puts "  Sauté nutriment : alim_code=#{alim_code}, nutrient_code=#{nutrient_code}, value=#{value}, source_code=#{source_code}"
          skipped_nutrients += 1
          next
        end

        # Gérer les valeurs non numériques
        if value == '-' || value == 'traces' || value.empty? || value.match?(/\A\s*-+\s*\z/)
          value = BigDecimal('0.0')
        elsif value.start_with?('<')
          value = BigDecimal('0.0')
        else
          begin
            value = BigDecimal(value.tr(',', '.'))
          rescue ArgumentError => e
            puts "  Erreur lors de la conversion de la valeur pour alim_code=#{alim_code}, nutrient_code=#{nutrient_code}: valeur='#{value}', erreur=#{e.message}"
            value = BigDecimal('0.0')
            skipped_nutrients += 1
            next
          end
        end

        foods[alim_code][:nutrients][nutrient_code] = value
        nutrient_count += 1
      end
      puts "  Tous les alim_code trouvés : #{all_alim_codes.uniq.compact.sort.count}"
      puts "  => #{nutrient_count} valeurs de nutriments parsées, #{skipped_nutrients} sautés."

      # 4. Importer dans la base
      puts "Étape 4 : Importation dans la base..."
      ActiveRecord::Base.transaction do
        imported_count = 0
        skipped_ingredients = 0
        foods.each do |code, data|
          ingredient = Ingredient.find_or_initialize_by(ciqual_code: code, source: 'Ciqual')
          ingredient.assign_attributes(
            name: data[:name],
            energy_kcal: data[:nutrients]['328']&.to_f || 0.0,
            proteins: data[:nutrients]['25000']&.to_f || 0.0,
            fats: data[:nutrients]['40000']&.to_f || 0.0,
            carbs: data[:nutrients]['31000']&.to_f || 0.0,
            sugars: data[:nutrients]['32000']&.to_f || 0.0,
            fibers: data[:nutrients]['34100']&.to_f || 0.0,
            food_group: data[:food_group]
          )

          begin
            ingredient.save!
            imported_count += 1
            # Log tous les 50 ingrédients
            if (imported_count % 50).zero?
              puts "  Ingrédient importé (#{imported_count}/#{foods.keys.count}): ciqual_code=#{code}, name=#{data[:name]}, fats=#{ingredient.fats}, proteins=#{ingredient.proteins}, carbs=#{ingredient.carbs}, ratio=#{ingredient.ratio}"
            end
          rescue ActiveRecord::RecordInvalid => e
            puts "Erreur pour l'aliment #{code} (#{data[:name]}): #{e.message}"
            skipped_ingredients += 1
          end
        end
        puts "  => #{imported_count} ingrédients importés, #{skipped_ingredients} sautés."
      end

      puts "Importation terminée !"
    rescue StandardError => e
      puts "Erreur générale : #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
end
