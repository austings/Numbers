//Author Austin Sierra
//Last Change Sept 4, 2023 
//for Church of AI Christ
//Subject to Creative Commons BY-NC 4.0


//Require Tensor3D structure
//Require FileBMP structure 
//Cd(__DIR__);;
//#include "FileBMP.HC";
#include "Tensor3D.HC";

//Return Individual RGBValues
I64 ColorValueCast(CBGR24 *ptr, U8 RGoB)
{
  //Print("%d",ptr->r);
  switch(RGoB)
  {
   case 0:
    return ptr->r;//0r
    break;
   case 1:
    return ptr->g;//1g
    break;
   case 2:
    return ptr->b;//2b
    break;
  }

  return 0;

}


//Filepath of BMP returns as Tensor *bmpt3d
Tensor3D *BMPFileToTensor(U8 *filename)
{
  //File information including device context
  CFileBMP *bmp;
  U8 *ptr;
  CDC *res=NULL;
  Tensor3D *bmpt3d=NULL;

  I64 i,j;
  if (ptr=FileRead(filename)) 
  {
    bmp=ptr;
    if (0<bmp->width<I32_MAX && 0<bmp->height<I32_MAX) 
    {
      //Size of Return Tensor 

      Vector *sz = CreateVector(3);  
      SetVector(sz,bmp->width,0);//height
      SetVector(sz,bmp->height,1);//width
      SetVector(sz,3,2);//channels 
      bmpt3d = CreateTensor(sz);

      //Print("%d\n",bmp->height);
      //Print("%d\n",bmp->width);

      ptr+=bmp->data_offset;     
      
      if (bmp->bit_cnt==32) 
      {
	for (i=bmp->height-1;i>=0;i--) 
        {
	  for (j=0;j<bmp->width;j++,ptr+=4) 
          {
            Vector *tmpV = CreateVector(3);

            SetVector(tmpV,ColorValueCast(ptr,2),0);//b
            SetVector(tmpV,ColorValueCast(ptr,1),1);//g
            SetVector(tmpV,ColorValueCast(ptr,0),2);//r

            SetTensorVectorZ(bmpt3d,tmpV,j,i);
            
            DestroyVector(tmpV);
          }
        }
      }
      else 
      {
	"\nFormat Not Supported.\n";
	DCDel(res);
	res=NULL;
      }
    } 
    else
    { 
      "\nInvalid BMP File\n";
    }
    Free(bmp);
  }
  return bmpt3d;
   

}


//Sept 7 AS
public CDC *BMPTensorRead(Tensor3D*bmp,
    Bool dither_probability=FALSE)
{//Display Tensor on Screen.
  I64 i,j;
  CDC *res=NULL;
  I64 bmpW = GetVector(bmp->shape,0);
  I64 bmpH = GetVector(bmp->shape,1);
  //I64 bmpC = GetVector(bmp->shape,2);
  res =DCNew(bmpW,bmpH);
  for (i=bmpH-1;i>=0;i--){
    for (j=0;j<bmpW;j++) {
      CBGR24 *curr=NULL;
      curr->b = GetTensor(bmp,j,i,0);
      curr->g = GetTensor(bmp,j,i,1);
      curr->r = GetTensor(bmp,j,i,2);
      res->color=BMP24Color(curr,dither_probability);
      GrPlot(res,j,i);
    }    
  } 
    
  //Free(bmp);
  return res;
}

public U0 RGBTMain()
{
  //for testing
  Tensor3D *five = BMPFileToTensor("C:/Home/Perceptrons/BMP/cat.0.bmp");
  PrintTensor(five);
  DestroyTensor(five);

}//RGBTMain;  