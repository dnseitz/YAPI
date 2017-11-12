//
//  YelpV3Localization.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/4/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public protocol Language {
  var rawValue: String { get }
}

/*
func initNetworkConnection() {
  var readStream: Unmanaged<CFReadStream>?
  var writeStream: Unmanaged<CFWriteStream>?
  
  CFStreamCreatePairWithSocketToHost(kCFAllocatorNull, "localhost" as CFString!, 1234, &readStream, &writeStream)
  
  let inputStream = readStream!.takeRetainedValue()
  let outputStream = writeStream!.takeRetainedValue()
}
*/

public enum YelpLocale {
  public enum Czech : String, Language {
    case czechRepublic = "cs_CZ"
  }
  
  public enum Danish : String, Language {
    case denmark = "da_DK"
  }
  
  public enum German : String, Language {
    case austria = "de_AT"
    case switzerland = "de_CH"
    case germany = "de_DE"
  }
  
  public enum English : String, Language {
    case belgium = "en_BE"
    case canada = "en_CA"
    case switzerland = "en_CH"
    case unitedKingdom = "en_GB"
    case hongKong = "en_HK"
    case republicOfIreland = "en_IE"
    case malaysia = "en_MY"
    case newZealand = "en_NZ"
    case philippines = "en_PH"
    case singapore = "en_SG"
    case unitedStates = "en_US"
  }
  
  public enum Spanish : String, Language {
    case argentina = "es_AR"
    case chile = "es_CL"
    case spain = "es_ES"
    case mexico = "es_MX"
  }
  
  public enum Finnish : String, Language {
    case finland = "fi_FI"
  }
  
  public enum Filipino : String, Language {
    case philippines = "fil_PH"
  }
  
  public enum French : String, Language {
    case belgium = "fr_BE"
    case canada = "fr_CA"
    case switzerland = "fr_CH"
    case france = "fr_FR"
  }
  
  public enum Italian : String, Language {
    case switzerland = "it_CH"
    case italy = "it_IT"
  }
  
  public enum Japanese : String, Language {
    case japan = "ja_JP"
  }
  
  public enum Malay : String, Language {
    case malaysia = "ms_MY"
  }
  
  public enum Norwegian : String, Language {
    case norway = "nb_NO"
  }
  
  public enum Dutch : String, Language {
    case belgium = "nl_BE"
    case theNetherlands = "nl_NL"
  }
  
  public enum Polish : String, Language {
    case poland = "pl_PL"
  }
  
  public enum Portuguese : String, Language {
    case brazil = "pt_BR"
    case portugal = "pt_PT"
  }
  
  public enum Swedish : String, Language {
    case finland = "sv_FI"
    case sweden = "sv_SE"
  }
  
  public enum Turkish : String, Language {
    case turkey = "tr_TR"
  }
  
  public enum Chinese : String, Language {
    case hongKong = "zh_HK"
    case taiwan = "zh_TW"
  }
}
