//Last Change Sept 3, 2023 
//By Austin Sierra
//for Church of AI Christ
//Subject to Creative Commons BY-NC 4.0



//requires matrix implementation
//Cd(__DIR__);;

#include "Matrix.HC";



//Tensor Object Declaration
public class Tensor3D
{
 Vector *shape;
 Matrix *data;
 Tensor3D *last,*next; 

};

//Initialize a Tensor of vector tensorShape

/*Tensor constructor that takes a shape to initialize the 

 *tensor's dimensions.

 *
 *It is of I64 values, where each value corresponds to the
 *size of a specific dimension of the tensor that determines rank.
 *To create a Rank 3 Tensor pass {height,width, 3}
 */
Tensor3D *CreateTensor(Vector *tensorShape)
{
 I64 x=0,y=0,z=0, tsSz = tensorShape->size;
 Tensor3D *t = MAlloc(sizeof(Tensor3D));
 Tensor3D *first = t;
 t->shape = tensorShape;//CreateVector(tsSz);
 switch(tsSz)
 {
   case 0:
    t->data = CreateMatrix(1,1);
    t->last = t;
    t->next = t;
    break;

   case 1:
    x = GetVector(t->shape,0);
    t->data = CreateMatrix(x,1);
    t->last = t;
    t->next = t;
    break;

   case 2:
    x = GetVector(t->shape,0);
    y = GetVector(t->shape,1);
    t->data = CreateMatrix(x,y); 
    t->last = t;
    t->next = t;     
    break;

   case 3:
    x = GetVector(t->shape,0);
    y = GetVector(t->shape,1);
    z = GetVector(t->shape,2);
    while(z>0)
    {
     t->data = CreateMatrix(x,y);

     if(z!=1)
     {
      Tensor3D *temp = t;
      t->next=MAlloc(sizeof(Tensor3D));
      t= t->next;
      t->last =temp;
     }
     else
     {
      t->next=first;
      first->last = t;
      t = t->next;
     }
     z--;
    }
    break;
 }
 return t;

}

//Set value d at position x,y,z
U0 SetTensor(Tensor3D *t, F64 d, I64 x=0, I64 y=0, I64 z=0)
{
 Vector *v = t->shape;
 I64 sz = v->size;
 switch(sz)
 {
  case 0:
   SetMatrix(t->data,d,0,0);
   break;

  case 1:
   SetMatrix(t->data,d,0,x);
   break;

  case 2:
   SetMatrix(t->data,d,x,y);
   break;

  case 3:
   sz= GetVector(v,2);
   I64 tot = 0;
   while(sz>0)
   {
    if(tot==z)
    {
     SetMatrix(t->data,d,x,y);
    }
    t = t->next;
    sz--;tot++;
   }
   break;

 }

}



/*

  Takes a Vector d and updates values at x,z across Y level

*/
U0 SetTensorVector(Tensor3D *t, Vector *d, I64 x=0, I64 z=0)
{
 Vector *v = t->shape;
 I64 sz = v->size;
 switch(sz)
 {
  case 0:
   "Cannot set vector on 0D Tensor";
   PutExcept;
   break;
  case 1:
   SetMatrixVector(t->data,d,0);
   break;
  case 2:
   SetMatrixVector(t->data,d,x);
   break;
  case 3:
   sz= GetVector(v,2);
   I64 tot = 0;
   while(sz>0)
   {
    if(tot==z)
    {
     SetMatrixVector(t->data,d,x);
    }
    t = t->next;
    tot++;sz--;
   }
   break;
  
 }

 
}

/*

  Takes a Vector d and updates values at x,y across Z level

*/
U0 SetTensorVectorZ(Tensor3D *t, Vector *d, I64 x=0, I64 y=0)
{
 Vector *sz = t->shape;
 I64 szt= GetVector(sz,2), z=0;
 switch(szt)
 {
  case 0:
   "Cannot set vector ascross z on < 3D Tensor";
   PutExcept;
   break;
  case 1:
   "Cannot set vector across z on < 3D Tensor";
   PutExcept;
   break;
  case 2:
   "Cannot set vector across z on < 3D Tensor";
   PutExcept;
   break;
  case 3:
   while(z<3)
   {
    //Print("\n%d,%d,%d\n",x,y,z);
    F64 val = GetVector(d,z);
    SetTensor(t,val,x,y,z);
    z++;
   }
   break;
  
 } 
}


//Get F64 val from position x,y,z from tensor t
F64 GetTensor(Tensor3D *t,I64 x=0,I64 y=0,I64 z =0)
{
 Vector *v = t->shape;
 I64 sz = v->size;

 switch(sz)
 {
  case 0:
   return GetMatrix(t->data,0,0);
   break;

  case 1:
   return GetMatrix(t->data,0,x);
   break;

  case 2:
   return GetMatrix(t->data,x,y);
   break;

  case 3:
   sz= GetVector(v,2);
   I64 tot = 0;
   I64 val = 0;
   while(tot<sz)
   {
    if(tot==z)
    {
     val= GetMatrix(t->data,x,y);
    }
    t = t->next;
    tot++;
   }
   return val; 
  break; 

 }

}

/*
* Checks the size and stride and returns a new tensor
* with zero padding so that no pixels are skipped.
*
* God says forth sings immense unawares 
*/
Tensor3D *ZeroPadTensor(Tensor3D *original,I32 size,I32 stride)
{
  I64 i_w = GetVector(original->shape,0);
  I64 i_h = GetVector(original->shape,1);
  I64 i_d = GetVector(original->shape,2);
  I64 pad_w=0,pad_h=0,i,j;
  F64 a,b,c;

  //determine if calculating padding is necessary
  if(i_w % stride!=0 && (i_w%stride)%size!=0)
  {
    pad_w= (size-i_w%stride)%stride;
    if(pad_w<1)
      pad_w=0;
  
  }
  if(i_h % stride!=0 && (i_h%stride)%size!=0)
  {
    pad_h= (size-i_h%stride)%stride;
    if(pad_h<1)
      pad_h=0;
  
  }
  if(pad_w==0&&pad_h==0)
    return original;
   
  //calculate the new tensor 
  Vector *newSize = CreateVector(3);
  SetVector(newSize,i_w+pad_w,0);
  SetVector(newSize,i_h+pad_h,1);
  SetVector(newSize,i_d,2);

  Print("\n%d,%d\n",i_w,i_h);
  Print("\n%d,%d\n",i_w+pad_w,i_h+pad_h);
//TODO:fix this padding leaving zeros and overall sucks

  Tensor3D*newT = CreateTensor(newSize);
  for(i=0;i<i_w+pad_w;i++)
  {
   if(i>=pad_w&&i<=i_w-pad_w)
   {  
    for(j=0;j<i_h+pad_h;j++)
    {
     if(j>=pad_h&&j<=i_h-pad_h)
     {
       a=GetTensor(original,i,j,0);
       b=GetTensor(original,i,j,1);
       c=GetTensor(original,i,j,2);
       SetTensor(newT,a,i,j,0);
       SetTensor(newT,b,i,j,1);
       SetTensor(newT,c,i,j,2);
     }
    }
   } 
  }
  return newT;
  
}

U0 PrintTensor(Tensor3D *t)
{
 Vector *v = t->shape;

 I64 sz = v->size;

 switch(sz)
 {
  case 0:
   Print("[ %.5f ]",GetMatrix(t->data,0,0));"\n";
   break;

  case 1:
   PrintVector(GetMatrixVector(t->data,0));
   break;

  case 2:
   PrintMatrix(t->data);
   break;

  case 3:
   I64 z= GetVector(v,2);
   I64 tot = z;
   "Plane 0:\n";
   while(z>0)
   {
    PrintMatrix(t->data);
    "\n";
    t = t->next;
    z--;
    if(z!=0)
    {
     Print("Plane %d \n",tot-z);
    }
   } 
  break; 
 } 
}

//Free a created Tensor3D t
U0 DestroyTensor(Tensor3D *t)
{
 //Vector *v = t->shape;
 I64 i, z=GetVector(t->shape,2);
 DestroyVector(t->shape);
 for(i=0;i<z;i++)
 {
   Matrix *m = t->data;
   DestroyMatrix(m);
   t = t->last; 
   Free(t->next);
 }
}

U0 MainTensor()
{
  //Set Test Vectors
  I32 vectorSize = 3;

  Vector *v1 = CreateVector(vectorSize); 
  SetVector(v1,2,0);  
  SetVector(v1,3,1);
  SetVector(v1,3,2);

  Vector *v2 = CreateVector(vectorSize);
  SetVector(v2,1,0);
  SetVector(v2,2,1);
  SetVector(v2,3,2);
 
  Tensor3D *t1 = CreateTensor(v1);

  SetTensorVector(t1,v2,0,0);
  SetTensorVector(t1,v2,0,1);
  SetTensorVector(t1,v2,0,2);
  SetTensorVector(t1,v2,1,0);
  SetTensorVector(t1,v2,1,1);
  SetTensorVectorZ(t1,v2,0,0);

  DestroyVector(v2);
 
  PrintTensor(t1);

  DestroyTensor(t1);

  

}//MainTensor;