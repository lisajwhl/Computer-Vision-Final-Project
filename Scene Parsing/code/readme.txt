main = myParsing_rcnn_testSiftFlowDataset_tryNoRGBhist_OK \ runTest.m

主要parsing code = parsingFunc.m

parsingFunc.m裡面下面兩個function只用一個
要看結果用show
要跑整個dataset的performance用performance (差在有沒有算cofusionMatrix)

可以下break point在parsingFunc.m最後面的end只跑一張圖
runTest.m的for i=1:200%length(testName)
這行可以下要跑哪一張 
test dataa目前設定有200張