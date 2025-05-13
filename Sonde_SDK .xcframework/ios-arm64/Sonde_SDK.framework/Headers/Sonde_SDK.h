//
//  FE_SDK.h
//  FE_SDK
//
//  Created by raj on 23/12/21.
//

#import <Foundation/Foundation.h>
#pragma once

#define E_ARG_ERR 21
//#import "sonde_spfe_api.h"


//int * sp_fe(t_int8 *input_filename, t_int8 *config_file, t_int8 *threshold_config_file, t_int8 *resources_dir, t_int8 *output_dir, t_int8 *model_path);



int * sp_fe(char * input_filename, char * config_file,char * threshold_config_file,char * resources_dir, char * output_dir, char *model_file);
            
//            , int  voice_sufficiency,int speech_length_threshold,int snr_thresholdb);

char * sp_elck(char * input_filename, char * config_file,char * threshold_config_file,char * resources_dir, char * output_dir);


//! Project version number for FE_SDK.
FOUNDATION_EXPORT double FE_SDKVersionNumber;

//! Project version string for FE_SDK.
FOUNDATION_EXPORT const unsigned char FE_SDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FE_SDK/PublicHeader.h>


