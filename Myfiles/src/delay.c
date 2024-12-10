#include "delay.h"

static uint8_t  fac_us=0;//us��ʱ������			   
static uint16_t fac_ms=0;//ms��ʱ������,��ucos��,����ÿ�����ĵ�ms��

void delay_init(uint8_t SYSCLK)
{
 	SysTick_CLKSourceConfig(SysTick_CLKSource_HCLK_Div8);
	fac_us=SYSCLK/8;		//�����Ƿ�ʹ��ucos,fac_us����Ҫʹ��
	
	fac_ms=(uint16_t)fac_us*1000;//��ucos��,����ÿ��ms��Ҫ��systickʱ����   
}								    

void delay_us(uint32_t nus)
{		
	uint32_t temp;	    	 
	SysTick->LOAD=nus*fac_us; //ʱ�����	  		 
	SysTick->VAL=0x00;        //��ռ�����
	SysTick->CTRL|=SysTick_CTRL_ENABLE_Msk ;          //��ʼ���� 
	do
	{
		temp=SysTick->CTRL;
	}
	while((temp&0x01)&&!(temp&(1<<16)));//�ȴ�ʱ�䵽��   
	SysTick->CTRL&=~SysTick_CTRL_ENABLE_Msk;       //�رռ�����
	SysTick->VAL =0X00;       //��ռ�����	 
}

void delay_xms(uint16_t nms)
{	 		  	  
	uint32_t temp;		   
	SysTick->LOAD=(uint32_t)nms*fac_ms;//ʱ�����(SysTick->LOADΪ24bit)
	SysTick->VAL =0x00;           //��ռ�����
	SysTick->CTRL|=SysTick_CTRL_ENABLE_Msk ;          //��ʼ����  
	do
	{
		temp=SysTick->CTRL;
	}
	while((temp&0x01)&&!(temp&(1<<16)));//�ȴ�ʱ�䵽��   
	SysTick->CTRL&=~SysTick_CTRL_ENABLE_Msk;       //�رռ�����
	SysTick->VAL =0X00;       //��ռ�����	  	    
} 
//��ʱnms 
//nms:0~65535
void delay_ms(uint16_t nms)
{	 	 
	uint8_t repeat=nms/540;	//������540,�ǿ��ǵ�ĳЩ�ͻ����ܳ�Ƶʹ��,
						//���糬Ƶ��248M��ʱ��,delay_xms���ֻ����ʱ541ms������
	uint16_t remain=nms%540;
	while(repeat)
	{
		delay_xms(540);
		repeat--;
	}
	if(remain)delay_xms(remain);
	
} 
