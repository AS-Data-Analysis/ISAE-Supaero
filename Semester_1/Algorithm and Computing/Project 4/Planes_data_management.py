import json
from time import gmtime, strftime
import matplotlib.pyplot as plt
import folium

# Opening smallOpenSkyData.json

data_file = open('data/smallOpenSkyData.json')
json_string = data_file.read()
small_data = json.loads(json_string)


# Access to any value

def access(obs,prop):
    return small_data['states'][obs][prop]


# Opening mediumOpenSkyData.json

data_file = open('data/mediumOpenSkyData.json')
json_string = data_file.read()
medium_data = json.loads(json_string)


# Number of planes in the air

def num_of_obs(data):
    c=0
    for i in data:
        if i['on_ground']!=True:
            c+=1
    print(f"Currently there are {c} planes in the air")

num_of_obs(medium_data['states'])


# List of countries

def num_of_countries(data):
    my_list=[]
    for i in data:
        if i['origin_country']!=None and i['origin_country']!='':
            my_list.append(i['origin_country'])
    my_list=list(set(my_list))
    print(my_list)
    
num_of_countries(medium_data['states'])


# Earliest and latest time position reports

time_pos = []
for i in medium_data['states']:
    if i['time_position']!=None:
        time_pos.append(i['time_position'])
        
print('earliest time position report : ')
print(strftime("%a, %d, %b, %Y %H:%M:%S +0000", gmtime(max(time_pos))))
print('latest time position report : ')
print(strftime("%a, %d, %b, %Y %H:%M:%S +0000", gmtime(min(time_pos))))


# Distribution of the altitudes

altitudes = []
for i in medium_data['states']:
    if i['altitude']!=None:
        altitudes.append(i['altitude'])

plt.hist(altitudes,bins=100)


# Planes in Toulouse on the map
 
m= folium.Map(location=[43.6, 1.4],zoom_start=12)

latitudes=[]
longitudes=[]

for i in medium_data['states']:
    latitudes.append(i['latitude'])
    longitudes.append(i['longitude'])

def planes():
    for i in range(len(latitudes)):
        if latitudes[i]!=None and longitudes[i]!=None:
            if 43.55<latitudes[i]<43.68 and 1.3<longitudes[i]<1.55:
                folium.Marker([latitudes[i],longitudes[i]]).add_to(m)
                m.save('myMap.html')

planes()