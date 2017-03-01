from bs4 import BeautifulSoup
import requests
import pprint as pp
import codecs
import re

#pg = requests.get("https://cdec.water.ca.gov/cgi-progs/reservoirs/STORSUM")
#pg = requests.get("http://cdec.water.ca.gov/misc/monthly_res.html")
pg = requests.get("http://cdec.water.ca.gov/misc/resinfo.html")

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
	#print(len(col))
	#print("####")
 	if col:
		res_id = col[0].get_text().encode('ascii', 'replace')
		dam = col[1].get_text().encode('ascii', 'replace')
		lake = col[2].get_text().encode('ascii', 'replace')
		stream = col[3].get_text().encode('ascii', 'replace')
		capacity = col[4].get_text().encode('ascii', 'replace')
	 	record = ('%s;%s;%s;%s;%s;') % (res_id, dam, lake, stream, capacity)
# 	 		print(record)
 		records.append(record+'\n')

print("saving to file")
fl = codecs.open('rerservoir_capinfo.txt', 'wb')
line = ';'.join(records)
fl.write(line + u'\r\n')
fl.close()