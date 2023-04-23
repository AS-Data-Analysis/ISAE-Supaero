# -*- coding: utf-8 -*-
import folium
 
m= folium.Map(location=[43.6, 1.4],zoom_start=12)

folium.Marker( [43.5661107 , 1.474090], popup='<i>ISAE-Supaero</i>').add_to(m)
folium.Marker( [43.604696 , 1.445107 ], popup='<i>Toulouse Capitole</i>').add_to(m)

m.save('myMap.html')