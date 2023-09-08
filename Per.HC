Cd(__DIR__);;

#include "BMPView.HC";

//MaxPooling
//define size and stride
//return output of
Tensor3D *MaxPooling(Tensor3D *img, I32 size, I32 stride)
{
 if(size>1)
 {
  img = ZeroPadTensor(img,size,stride);
  I64 bmpW = GetVector(img->shape,0);
  I64 bmpH = GetVector(img->shape,1);
  I64 bmpC = GetVector(img->shape,2);
  I64 w_out= ((bmpW-size)/stride)+1;
  I64 h_out= ((bmpH-size)/stride)+1;
  I64 area = size*size,aW=0,aH=0;
  F64 maxValue = 0,k;
  I64 i,j,g,strideIncrementI=0,strideIncrementJ=0;//indexes

  Vector *osz = CreateVector(3);
  SetVector(osz,w_out,0);
  SetVector(osz,h_out,1);
  SetVector(osz,3,2);

  Matrix*kernel = CreateMatrix(size,size);
  Tensor3D *output = CreateTensor(osz);
  "\nHi\n";
  for(g=0;g<bmpC;g++){
   for (i=0;i<h_out;i++){
    for (j=0;j<w_out;j++) {
     //apply kernel on input and save to output
     while((aW+1)*(aH+1)!=area)
     {
      k =GetTensor(img,strideIncrementJ+aW,
        strideIncrementI+aH,g);

      if(maxValue<k)
       maxValue = k;

      if(aW==size-1)
      {
       aH++;
       aW=0;
      }
      else
      {
       aW++;
      }  
     }
  
     //last tile, then reset
     k =GetTensor(img,strideIncrementJ+aW,
        strideIncrementI+aH,g);

     if(maxValue<k)
      maxValue = k;


     SetTensor(output,maxValue,j,i,g);
     aW=0;aH=0;maxValue=0;
     strideIncrementJ = strideIncrementJ+stride;
    
    }
    Print("%d,",i);
    strideIncrementI = strideIncrementI+stride;
   }
  }

  DestroyMatrix(kernel);
  DestroyTensor(img);
  return output;
 }
 return img;
}

U0 Percept()
{
  I32 stride =2;
  I32 size = 2; 


  "\nScanning Images...";

  //Tensor3D *one = BMPFileToTensor("BMP/cat.0.bmp");  
  //Tensor3D *two = BMPFileToTensor("BMP/cat.1.bmp");
  //Tensor3D *three = BMPFileToTensor("BMP/cat.2.bmp");    
  //Tensor3D *four = BMPFileToTensor("BMP/cat.3.bmp");
  BMP24ViewTensor(MaxPooling(
           BMPFileToTensor("BMP/cat.0.bmp"),size,stride),1.0);
  //Tensor3D *input = ZeroPadTensor(img,size,stride);
 
  //Tensor3D *six = BMPFileToTensor("BMP/cat.5.bmp"); 
  //Tensor3D *seven = BMPFileToTensor("BMP/cat.6.bmp");
  //Tensor3D *eight = BMPFileToTensor("BMP/cat.7.bmp"); 
  //Tensor3D *nine = BMPFileToTensor("BMP/cat.8.bmp");
  //Tensor3D *ten = BMPFileToTensor("BMP/cat.9.bmp");
  //Tensor3D *eleven = BMPFileToTensor("BMP/cat.10.bmp");
  //Tensor3D *twelve = BMPFileToTensor("BMP/cat.11.bmp");
  //Tensor3D *five = BMPFileToTensor(filename);
 
 
  //"\nBeginning Maximum Pooling...";
   // Tensor3D *print = MaxPooling(img,size,stride);
    //BMP24ViewTensor(print,1.0);
  //PrintTensor(print);
  //DestroyTensor(one);  
  //DestroyTensor(two);  
  //DestroyTensor(three);  
  //DestroyTensor(four);  
  //DestroyTensor(five); 
  //DestroyTensor(six);  
  //DestroyTensor(seven); 
  //DestroyTensor(eight);  
  //DestroyTensor(nine);  
  //DestroyTensor(ten);
  //DestroyTensor(eleven);  
  //DestroyTensor(twelve);
}
Percept;