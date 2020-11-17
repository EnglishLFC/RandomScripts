#!/opt/local/bin/python
"""
 COVID-19 Stats for the US

 Copyright: Nigel Houghton <wutang@warpten.net>
 $Id$

"""

import urllib.request
import json
import requests
import time

url = "https://corona-stats.online/US"
querystring = {"format":"json"}
response = requests.request("GET", url, headers=headers, params=querystring)
data = response.json()

# If you want to see the JSON data, uncomment the next line
# print(json.dumps(data, indent = 4, sort_keys = True))

# Format numbers to use comma separators
def place_value(number):
    return("{:,}".format(number))
# Pretty print text strings to line things up a bit
def pretty_print(str):
    return("{:15}".format(str))

for info in data['data']:
    deaths = info['deaths']
    cases = info['cases']
    population = info['population']
    todaycases = info['todayCases']
    recovered = info['recovered']
    datatime = info['updated']
    datatime = time.strftime("%A, %B %d %Y %r", time.localtime(int(datatime/1000)))
    deathrate = str(round((deaths/cases)*100, 2)) + "%"
    recoveryrate = str(round((recovered/cases)*100, 2)) + "%"
    percentinfected = str(round((cases/population)*100, 2)) + "%"

print("As of", datatime)
print(pretty_print("US Population:"),place_value(population))
print(pretty_print("Cases:"),place_value(cases))
print(pretty_print("Deaths:"),place_value(deaths))
print(pretty_print("New Cases:"),place_value(todaycases))
print(pretty_print("Death rate:"),deathrate)
print(pretty_print("Recovery rate:"),recoveryrate)
print(pretty_print("Infection rate:"),percentinfected)

