from bs4 import BeautifulSoup
import requests
import pprint as pp
import codecs
import re

#pg = requests.get("https://cdec.water.ca.gov/cgi-progs/reservoirs/STORSUM")
#pg = requests.get("http://cdec.water.ca.gov/misc/monthly_res.html")
#pg = requests.get("http://cdec.water.ca.gov/misc/resinfo.html")
pg = requests.get("http://cdec.water.ca.gov/cgi-progs/reservoirs/RES")

bs = BeautifulSoup(pg.content, "lxml")

tables = bs.find_all("table")
table = tables[0]
#table1 = tables[0]
#table2 = tables[1]
#table3 = tables[2]

pp.pprint(len(table))

records = []

for row in table.find_all('tr'):
	col = row.find_all('td')
	print(len(col))
	#print("####")
  	if col:
  		if len(col) == 12:
			res_name = col[0].get_text().encode('ascii', 'replace')
			station_id = col[1].get_text().encode('ascii', 'replace')
			capacity_af = col[2].get_text().encode('ascii', 'replace')
			elevation_ft = col[3].get_text().encode('ascii', 'replace')
			storage_af = col[4].get_text().encode('ascii', 'replace')
			storage_change = col[5].get_text().encode('ascii', 'replace')
			perc_capacity = col[6].get_text().encode('ascii', 'replace')
			avg_storage = col[7].get_text().encode('ascii', 'replace')
			perc_average = col[8].get_text().encode('ascii', 'replace')
			outflow_cfs = col[9].get_text().encode('ascii', 'replace')
			inflow_cfs = col[10].get_text().encode('ascii', 'replace')
			storage_yearagotoday = col[11].get_text().encode('ascii', 'replace')
	 		record = ('%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;') % (res_name, station_id, capacity_af, elevation_ft, storage_af, storage_change, perc_capacity, avg_storage, perc_average, outflow_cfs, inflow_cfs, storage_yearagotoday)
  			records.append(record+'\n')

		elif len(col) == 11:
			area = col[0].get_text().encode('ascii', 'replace')
	 		record = ('%s;') % (area)
  			records.append(record+'\n')

print("saving to file")
fl = codecs.open('rerservoir_storage_todate.txt', 'wb')
line = ';'.join(records)
fl.write(line + u'\r\n')
fl.close()



