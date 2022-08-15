Trade:([] time  	: `timespan$(); 
          sym   	: `$(); 
          price 	: `float$(); 
	  size  	: `int$());

Quote:([] time  	: `timespan$(); 
          sym   	: `$(); 
          bid   	: `float$(); 
          ask   	: `float$(); 
	  bidSize 	: `int$(); 
	  askSize 	: `int$());

Aggregation:([] time  		: `timespan$(); 
          sym   		: `$(); 
	  maxTradePrice 	: `float$(); 
	  minTradePrice 	: `float$(); 
	  tradedVolume   	: `long$(); 
	  maxBid     		:`float$(); 
	  minAsk     		:`float$());
