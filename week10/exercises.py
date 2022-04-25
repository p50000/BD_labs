from dateutil.parser import parse
from pymongo import MongoClient

client = MongoClient("mongodb://localhost")
db = client['someDB']
collection = db.get_collection('restaurants')

def ex1_first():
    ans = collection.find({'cuisine': 'Indian'})
    for item in ans:
        print(item)

def ex1_seconnd():
    ans = collection.find({"$or": [{'cuisine': "Indian"}, {'cuisine': "Thai"}]})
    for item in ans:
        print(item)

def ex1_third():
    for item in collection.find():
        address = item['addr']
        if address['building'] == "1115" and address['street'] == "Rogers Avenue" and address["zipcode"] == "11226":
            print(item)

def ex2():
    restaurant = {
        "address": {
            "building": "1480",
            "coord": [
                -73.9557413,
                40.7720266
            ],
            "street": "2 Avenue",
            "zipcode": "10075"
        },
        "borough": "Manhattan",
        "cuisine": "Italian",
        "grades": [
            {
                "date": {
                    "$date": parse("2014-10-01T00:00:00Z")
                },
                "grade": "A",
                "score": 11
            }
        ],
        "name": "Vella",
        "restaurant_id": "41704620"
    }
    collection.insert_one(restaurant)


def ex3_first():
    collection.delete_one({'borough' : 'Manhattan'})

def ex3_second():
    collection.delete_many({'cuisine' : 'Thai'})

def ex4():
    for item in collection.find():
        if item['address']['street'] == "Rogers Avenue":
            for grade in item['grades']:
                if grade['grade'] == 'C':
                    collection.delete_one(item)
                    break
                else:
                    item_gr = item['grades']
                    item_gr.append(
                        {
                            "date": {
                                "$date": parse("2022-04-25T00:00:00Z")
                            },
                            "grade": "C",
                            "score": 0
                        }
                    )
                    collection.update_one({'_id' : item['_id']}, {'$set' : {'grades' :  item_gr}})