//: Playground - noun: a place where people can play

import UIKit

var n = NSURLComponents()

let s = "blah"
// Note that the values here should not be % encoded
let item1 = NSURLQueryItem(name: "password1", value: "ab%&")
let item2 = NSURLQueryItem(name: "password2", value: "{\"uniqueKey\":\"1234\"}")

n.host = "https"


n.queryItems = [item1, item2]

n.URL?.query

n.queryItems?.count

n.queryItems![0].name
n.queryItems![0].value

n.queryItems![1].name
n.queryItems![1].value


n.percentEncodedQuery?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())
var query:String = item2.name + "=" + item2.value!
let newQ = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())

NSURL(string: newQ!)