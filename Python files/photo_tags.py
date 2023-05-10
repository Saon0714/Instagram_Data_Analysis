import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    photo_tags=pd.read_csv('photo_tags.csv')
    return photo_tags


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    photo_tags=read_data_from_csv()

    #Remove Unwanted columns
    photo_tags.rename(columns = {"photo":"photo_id","tag ID":"tag_id"},inplace = True)
    photo_tags = photo_tags.drop(columns = ["user id"])

    
    #rename columns, only these columns are allowed in the dataset
    # 1.	photo_id
    # 2.	tag_id
    
    #export cleaned Dataset to newcsv file named "photo_tags_cleaned.csv"
    photo_tags.to_csv('photo_tags_cleaned.csv')
    return photo_tags


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()