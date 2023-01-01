# CNN 
import tensorflow.compat.v1 as tf
import tensorflow.keras
tf.disable_v2_behavior()
mnist = tf.keras.datasets.mnist.load_data()

# placeholder 는 데이터를 담을 그릇의 의미이다
x = tf.placeholder(tf.float32, [None, 784]) 
W = tf.Variable(tf.zeros([784,10])) # 소프트맥스 연산을 위한 변수로 알고리즘이 찾아내야 하는 값 (tf.Variable은 텐서플로우에서 계속해서 업데이트 해줄 변수를 의미)
b = tf.Variable(tf.zeros([10])) # 소프트맥스 연산을 위한 변수로 알고리즘이 찾아내야 하는 값 
y = tf.nn.softmax(tf.matmul(x,W)+b) # 소프트맥스 함수 (tf.matmul은 dot product 연산이다)

# Cross-entropy 설정(Softmax regression 모델이 잘 학습하고 있는 평가하는 함수) 
# 모델의 예측값이 실제 참값을 설명하는데 얼마나 비효율적인지를 나타나며 작을수록 좋다 
y_ = tf.placeholder(tf.float32, [None, 10])
c_e = tf.reduce_mean(-tf.reduce_sum(y_*tf.log(y), reduction_indices=[1])) 
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(c_e)

# 경사하강법 (Cross-entropy를 최적화 하는 방법)
# 비선형함수의 최소화 방법 중 가장 단순한 방법으로 함수의 기울기를 구하여 기울기가 낮은 쪽으로 계속
# 이동시켜 극 값에 이를 때까지 반복시키는 방법
init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init)
for i in range(1000):
  batch_xs, batch_ys = mnist.train.next_batch(100)
  sess.run(train_step, feed_dict={x:batch_xs, y_:batch_ys})
  
# 정확도 판단
correct_pridict = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_pridict,tf.floa32))
print(sess.run(accuracy, feed_dict={x:mnist.test.images, y_:mnist.test.lables}))
