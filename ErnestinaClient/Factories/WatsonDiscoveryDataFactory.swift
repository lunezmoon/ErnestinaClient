//
//  WatsonDiscoveryQueryFactory.swift
//  Watson_Project
//
//  Created by 針谷ひろき on 2018/07/07.
//  Copyright © 2018年 test. All rights reserved.
//

import Foundation


class WatsonDiscoveryURLFactory {
    
    static func createData(intent:String) -> URL {
        
        if (intent == "SearchImage") {
            
            let urlString = "https://997fe7b2-1d42-45d6-adc1-8e2cdb3b5bf0:emVUkuZv3BRQ@gateway.watsonplatform.net/discovery/api/v1/environments/8f19b1db-57d0-489e-8f1a-755fdcead260/collections/68c3e84d-1d35-4218-bfb0-d8e1514b12eb/query?version=2017-11-07&aggregation=term%28enriched_text.entities.disambiguation.name%2Ccount%3A20%29&filter=extracted_metadata.filename%3A%3A%22GlobalWarming.pdf%22&deduplicate=false&highlight=true&passages=true&passages.count=5&query="
            
            let url = URL(string: urlString)!
            return url
        }
        
        return nil
    }
}
