import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    likes=pd.read_csv('likes.csv')
    return likes


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    likes=read_data_from_csv()

    #Remove Unwanted columns
   
    likes.rename(columns = {"user ":"user_id","photo":"photo_id","created time":"created_at"},inplace = True)
    likes = likes.drop(columns = ["like type","following or not"])

    
    
    #rename columns, only these columns are allowed in the dataset
    # 1.	user_id
    # 2.	photo_id
    # 3.	created_at
    
    #export cleaned Dataset to newcsv file named "likes_cleaned.csv"
    likes.to_csv('likes_cleaned.csv')
    return likes


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()