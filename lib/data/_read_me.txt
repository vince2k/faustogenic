Pour encoder correctement la table CIQUAL avant d'exécuter rails ciqual:import_xml


# Convertir alim_2020_07_07.xml
iconv -f windows-1252 -t UTF-8 lib/data/alim_2020_07_07.xml -o lib/data/alim_2020_07_07_utf8.xml

# Convertir alim_grp_2020_07_07.xml
iconv -f windows-1252 -t UTF-8 lib/data/alim_grp_2020_07_07.xml -o lib/data/alim_grp_2020_07_07_utf8.xml

# Convertir compo_2020_07_07.xml
iconv -f ISO-8859-1 -t UTF-8 lib/data/compo_2020_07_07.xml -o lib/data/compo_2020_07_07_utf8.xml

# Convertir const_2020_07_07.xml
iconv -f windows-1252 -t UTF-8 lib/data/const_2020_07_07.xml -o lib/data/const_2020_07_07_utf8.xml

# Convertir sources_2020_07_07.xml
iconv -f windows-1252 -t UTF-8 lib/data/sources_2020_07_07.xml -o lib/data/sources_2020_07_07_utf8.xml



# Corriger les entêtes
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/alim_2020_07_07_utf8.xml
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/compo_2020_07_07.xml
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/alim_grp_2020_07_07_utf8.xml
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/compo_2020_07_07_utf8.xml
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/const_2020_07_07_utf8.xml
sed -i 's/encoding="windows-1252"/encoding="UTF-8"/' lib/data/sources_2020_07_07_utf8.xml
