SiftFlowRegion_singleType:

	存放: 每張testing影像的rcnn feature
	形式: 每張影像都存在'image_name.mat'中，
	      'image_name.mat'皆包含3*1的cell，
	      第一個cell是4*n矩陣，n表示框到的object proposal數量，每一個column對應到一個region，應是region的左上右下座標，
	      第二個cell是4096*n矩陣，每一個column對應到一個region，應是region的cnn feature
	      第三個cell是64*n矩陣，好像是rgb顏色的histogram