//
//  WikipediaConstants.swift
//  WikipediaApp
//
//  Created by Ramakrishna on 9/23/18.
//  Copyright © 2018 Mindtree. All rights reserved.
//

import Foundation
let SEARCH_LIST_API = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages|pageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=150&pilimit=10&wbptterms=description&gpssearch=%@&gpslimit=10"
let SEARCH_DETAIL_API = "https://en.wikipedia.org/w/api.php?action=parse&redirects=1&page=%@&format=json"

