#Index Replication
------

Indexing is a common passive investment strategy where the goal is to mimic the performance of a portfolio of assets. It tends to avoid any forward-looking techniques and relies on diversification. Therefore, we care more about how close we are to the index rather than out-/under- performance. Index replication can be very difficult to implement in practice if there are many names, which leads to transaction costs and tracking error. In addition, impracticality compounds due to small positions and real-world constraints. An index fund likely tracks a benchmark, where full-replication is not the norm (with the exception of certain fund structures, such as the SPY).

If we want to construct an index fund, the value add comes from picking a selection of assets whose assets are smaller than the number of assets in that index. There are many methods to do this, such as stratified sampling (common in fixed income indices), leveraging different metrics such as yield-to-worst for more exotic assets (like callable bonds), or various other portfolio optimization methods.

In this example, we will be replicating an equity index using a similarity score: correlation as well as covariance. In addition, we will also incorporate a constraint that the problem must pick a number of stocks as an integer: thus we can formulate an integer program.

![](https://latex.codecogs.com/gif.latex?\-\hspace{2cm}&space;max&space;\sum\limits_{i=1}^n&space;\sum\limits_{j=1}^n&space;p_i_j&space;x_i_j&space;\\&space;&&space;\-\hspace{3cm}&space;s.t.&space;\sum\limits_{j=1}^n&space;y_j&space;=&space;s&space;\\&space;&&space;\-\hspace{3.5cm}&space;\sum\limits_{j=1}^n&space;x_i_j&space;=&space;1&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;for\&space;i&space;=&space;1,...,n&space;\\&space;\-\hspace{4cm}&space;x_i_j&space;\le&space;y_j&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;\&space;for\&space;i&space;=&space;1,...,n;&space;j&space;=&space;1,...n&space;\\&space;\-\hspace{4cm}&space;x_i_j&space;,y_j&space;=&space;0&space;\&space;or&space;\&space;1&space;\&space;\&space;for\&space;i&space;=&space;1,...,n;&space;j&space;=&space;1,...n&space;\\)



where:

![](https://latex.codecogs.com/gif.latex?p_i_j&space;=&space;similarity\&space;between\&space;stock\&space;i\&space;and\&space;j)


In this problem, we assume that we do not need to rebalance for the time being, and that correlation holds for the duration of that time. Of course there will be tracking error, but systematic indexing actually elicits a balancing act, in my opinion. There are many different industry practices, and this is just one approach.

For this exercise, we will extract financial data from QQQ, representing 100 large names. We will choose an arbitrary number of stocks for our index replication -75- and also view how the similarity metric impacts the tracking.


