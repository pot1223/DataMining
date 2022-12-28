# 유저들이 어떤 특성을 가지고 있을 때 또는 어떤 페이지를 방문했을 때 결제까지 전환되는 경향을 보이는지 패턴 파악 

# 세팅과 데이터 로드 
import pandas as pd 
import numpy as np
from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules
import math 
df = pd.read_csv("PAP_CH5_exercise_dataset.csv")

# 데이터에서 User Properties 추려내기 
df.groupby(by = "operating_system").count().sort_values(by="full_visitor_id", ascending = False)["full_visitor_id"].to_frame()

os_list = df["operating_system"].value_counts().nlargest(10).index.to_list() # 상위 10개만 사용 

df.groupby(by = "source").count().sort_values(by = "full_visitor_id", ascending = False )["full_visitor_id"].to_frame() 

source_list = df["source"].value_counts().nlargest(30).index.to_list() # 상위 30개만 사용 

df.groupby(by = "medium").count().sort_values(by = "full_visitor_id", ascending = False )["full_visitor_id"].to_frame() 

df.groupby(by = "country").count().sort_values(by = "full_visitor_id", ascending = False )["full_visitor_id"].to_frame() 

country_list = df["country"].value_counts().nlargest(10).index.to_list() # 상위 10개만 사용 

# 데이터에서 Event 추려내기 
df.groupby(by = "page_title").count().sort_values(by = "full_visitor_id", ascending = False )["full_visitor_id"].to_frame() 

page_title_list = df["page_title"].value_counts().nlargest(50).index.to_list() # 상위 50개만 사용 

# 최종 데이터셋 정제하기 
data = df[["full_visitor_id","visit_id","operating_system","country","source","medium","page_title"]]
print(data.shape)

data = data.loc[data["operating_system"].isin(os_list)]
data = data.loc[data["country"].isin(country_list)]
data = data.loc[data["source"].isin(source_list)]
data = data.loc[data["page_title"].isin(page_title_list)]
print(data.shape)

agg = data.groupby(by = ["visit_id","page_title"]).count()
agg = agg.reset_index()

events = agg.pivot(index = "visit_id", columns = "page_title", values = "full_visitor_id").reset_index()

events = events.fillna(0)
events.describe()

user_properties = data[["visit_id", "operating_system", "country", "source","medium"]]

user_properties.drop_duplicates(inplace = True)

dataset = pd.merge(left=events, right = user_properties, how = "inner", on = "visit_id")

dataset = pd.get_dummies(dataset) # 범주형 변수 더미변수화 

dataset = dataset.applymap(lambda x : 1 if x >0 else 0 ) # 더미변수가 아닌 경우의 연속형 변수를 0과 1로만 구성되도록 변환

del dataset["visit_id"]
dataset.head()


# Association Rule 진행
frequent_featuresets = apriori(dataset, min_support = 0.01, use_colnames = True, max_len = 3)
frequent_featuresets

frequent_featuresets.sort_values(by = "support", ascending = False, inplace= True)
frequent_featuresets

rules = association_rules(frequent_featuresets, metric = "lift", min_threshold = 0.001) # min_threshold는 최소 신뢰도이다 

result = rules[rules["consequents"].str.contains("Checkout Review", regex = False, na= False)].sort_values(by="lift", ascending = False)
result.head(20)

rules["interest_support"] = rules["lift"]*rules["support"].apply(lambda x: math.sqrt(x))
result = rules[rules["consequents"].str.contains("Checkout Review", regex = False, na =False)].sort_values(by="interest_support", ascending= False )
result.head(20)

# 결과 정리와 시각화
result["antecedents"] = result["antecedents"].apply(lambda x : list(x)).astype("unicode") # 리스트화 하여 ()를 없앤다 

trivial_rules = ["Checkout Confirmation", "Payment Method", "Checkout Your Information"] # 결제 전환 퍼널에 속하는 페이지들
filtered_rules = result[~result.antecedents.isin(trivial_rules)] # Trivial Rules 를 제외한 데이터 셋 
filtered_rules.head()

lift_top = filtered_rules.sort_values(by = "lift", ascending = False).head(15).index.to_list() # 특정 인덱스만 추출
filtered_rules.sort_values(by="lift", ascending=False).head(15)

Is_top = filtered_rules.sort_values(by = "interest_support", ascending = False).head(15).index.to_list()
filtered_rules.sort_values(by="interest_support", ascending=False).head(15)

top = lift_top + Is_top

top = list(set(top))
len(top)

filtered_rules = filtered_rules[filtered_rules.index.isin(top)]
filtered_rules.reset_index(inplace = True, drop = True)
print("####### Final Rules #######")
filtered_rules.sort_values(by="lift", ascending = False)

import matplotlib.pyplot as plt
import seaborn as sns
plt.style.use("seaborn-darkgrid")
plt.figure(figsize = (20,20))
sns.set(font_scale = 1)
ax = sns.scatterplot(filtered_rules["antecedent support"], filtered_rules["lift"], hue = filtered_rules["interest_support"], s = 10000, alpha = 0.35, color = "orange") # s는 버블 사이즈, alpha는 버블의 투명도를 의미 
for line in range(0, filtered_rules.shape[0]):
  ax.text(filtered_rules["antecedent support"][line], filtered_rules["lift"][line], filtered_rules["antecedents"][line], horizontalalignment = "center", size = "medium", color = "black" , weight = 0.35)

plt.show()
