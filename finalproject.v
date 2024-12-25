module finalproject(output [7:0] DATA_R, DATA_G, DATA_B,output reg [2:0]S, output reg COMM, input CLK, Clear, left, right);
	wire [7:0] D1;    
	wire [2:0] S1;    
	wire [7:0] D2;    
	wire [2:0] S2;    
	wire [7:0] D3;    
	wire [2:0] S3;    
	reg [1:0] count_1;    
	reg [3:0] count_2;    
	reg [3:0] count_3;        
	reg catch_g;          
	reg catch_r;          
	reg no_catch;	
	reg [4:0] score;      
	reg [2:0] cnt;        
	reg x;                
	reg gameover;
	reg restart;	
	divfreq F0(CLK,CLK_div);
	divfreq_1 F1(CLK,CLK_div1);
	divfreq_2 F2(CLK,CLK_div2);
	divfreq_3 F3(CLK,CLK_div3);
	divfreq_4 F4(CLK,CLK_div4);
	divfreq_5 F5(CLK,CLK_div5);
	divfreq_6 F6(CLK,CLK_div6);
	catchplate C0(D1,S1,CLK_div, CLK_div1, Clear, left, right);
	greencoin G0(D2,S2,CLK_div2, CLK_div3, Clear);
	redcoin R0(D3,S3,CLK_div4, CLK_div5, Clear);
	
	initial
		begin
		   x = 0;
			cnt = 0;
			COMM=1;
			catch_g=0;
			catch_r=0;
			no_catch=0;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			count_1=0;
			count_2=0;
			count_3=0;
			score=0;
			gameover=0;
		end
	
	/*分數*/
	always@(posedge catch_g,posedge catch_r,posedge no_catch,posedge Clear)
		begin
			if(Clear)
				begin
					score<=0;
					gameover=0;
				end	
			else if(catch_g==1)
				begin
					score<=score+1;
				end	
			else if(catch_r==1)
				begin
					score<=score+2;
				end	
			else if(no_catch==1)
				begin
					gameover<=1;
				end
		end
		
		
	/*遊戲畫面顯示*/
	always@(posedge CLK_div6,posedge Clear)
		begin
			if(Clear)
				begin
					count_1<=0;
					DATA_R<=8'b11111111;
					DATA_G<=8'b11111111;
					DATA_B<=8'b11111111;
					catch_g<=0;
					catch_r<=0;
					no_catch<=0;
					count_1<=count_1+1;
					if(count_1>2)
						count_1<=0;
					else if(count_1==0)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=D1;
							S<=S1;
						end
					else if(count_1==1)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=~D2;
							DATA_B<=8'b11111111;
							S<=S2;
						end	
					else if(count_1==2)
						begin
							DATA_R<=~D3;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=S3;
						end
				end
		else if(score<20)
			begin
				count_1<=0;
					DATA_R<=8'b11111111;
					DATA_G<=8'b11111111;
					DATA_B<=8'b11111111;
					catch_g<=0;
					catch_r<=0;
					no_catch<=0;
					count_1<=count_1+1;
					if(count_1>2)
						count_1<=0;
					else if(count_1==0)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=D1;
							S<=S1;
						end
					else if(count_1==1)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=~D2;
							DATA_B<=8'b11111111;
							S<=S2;
						end	
					else if(count_1==2)
						begin
							DATA_R<=~D3;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=S3;
						end
				 if((D1==~D2)&&(S1==S2)&&(D2 != 8'b00000000))
					begin 
						catch_g<=1;
						no_catch <= 0;
						restart<=1;
					end
				else
					begin
						catch_g<=0;
					end
				if((D1==~D3)&&(S1==S3)&& (D3 != 8'b00000000))
					begin 
						catch_r<=1;
						no_catch <= 0;
						restart<=1;
	
					end
				else
					begin
						catch_r<=0;
					end	
                
            // 判斷是否漏接硬幣
            // 只在硬幣到達最底部且確實沒有被接住時才觸發遊戲結束
            if(D2 == 8'b00000001)  // 綠色硬幣在底部
                begin
                    if(((D1 & ~D2) == 8'b10000000) && (S1 != S2))
                        no_catch <= 1;
                end
					 else
						begin
							no_catch <= 0; // 接住則不觸發漏接
						end
            if(D3 == 8'b00000001)  // 紅色硬幣在底部
                begin
                    if(((D1 & ~D3) == 8'b10000000) && (S1 != S3))
                        no_catch <= 1;
                end
					 else
						begin
							no_catch <= 0; // 接住則不觸發漏接
						end
			end
		else if(gameover==1)//失敗畫面
			begin
				count_2 <= count_2+1;
					if(count_2>7)
						count_2<=0;
					else if(count_2==0)
						begin
							DATA_R<=8'b01111110;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=0;		
						end
					else if(count_2==1)
						begin
							DATA_R<=8'b10111101;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=1;
						end
					else if(count_2==2)
						begin
							DATA_R<=8'b11011011;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=2;
						end
					else if(count_2==3)
						begin
							DATA_R<=8'b11100111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=3;
						end
					else if(count_2==4)
						begin
							DATA_R<=8'b11100111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=4;
						end
					else if(count_2==5)
						begin
							DATA_R<=8'b11011011;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=5;
						end
					else if(count_2==6)
						begin
							DATA_R<=8'b10111101;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=6;
						end
					else if(count_2==7)
						begin
							DATA_R<=8'b01111110;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11111111;
							S<=7;
						end
				end
			else if(score>=20)//通關畫面
				begin
					count_3 <= count_3+1;
					if(count_3>7)
						count_3<=0;
					else if(count_3==0)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11100111;
							S<=0;		
						end
					else if(count_3==1)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11000011;
							S<=1;
						end
					else if(count_3==2)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b10000001;
							S<=2;
						end
					else if(count_3==3)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b00000000;
							S<=3;
						end
					else if(count_3==4)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b00000000;
							S<=4;
						end
					else if(count_3==5)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b10000001;
							S<=5;
						end
					else if(count_3==6)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11000011;
							S<=6;
						end
					else if(count_3==7)
						begin
							DATA_R<=8'b11111111;
							DATA_G<=8'b11111111;
							DATA_B<=8'b11100111;
							S<=7;
						end
				end	
			
		end
		
endmodule
	
/*接盤*/	
module catchplate(output reg [7:0]DATA_B, output reg [2:0]S,input CLK_div, CLK_div1, Clear, left, right);
	parameter logic [7:0] B0_Char [7:0] = '{8'b11111111,  
														 8'b11111111,
														 8'b11111111,	
														 8'b11111111,
														 8'b11111111,
														 8'b01111111,
														 8'b01111111,
														 8'b01111111};

	parameter logic [7:0] B1_Char [7:0] = '{8'b11111111,    
														 8'b11111111,
														 8'b11111111,
														 8'b11111111,
														 8'b01111111,
														 8'b01111111,
														 8'b01111111,
														 8'b11111111};

	parameter logic [7:0] B2_Char [7:0] = '{8'b11111111,    
														 8'b11111111,
														 8'b11111111,
														 8'b01111111,
														 8'b01111111,
														 8'b01111111,
														 8'b11111111,
														 8'b11111111};

	parameter logic [7:0] B3_Char [7:0] = '{8'b11111111,    
														 8'b11111111,
														 8'b01111111,
														 8'b01111111,
														 8'b01111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111};
													 
	parameter logic [7:0] B4_Char [7:0] = '{8'b11111111,    
														 8'b01111111,
														 8'b01111111,
														 8'b01111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111};
													 
	parameter logic [7:0] B5_Char [7:0] = '{8'b01111111,    
														 8'b01111111,
														 8'b01111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111,
														 8'b11111111};
	bit [2:0]cnt;
	reg [2:0]x;
	// 防彈跳暫存器
    reg left_reg, right_reg;
    reg left_reg_delay, right_reg_delay;
	
	// 防彈跳處理
    always @(posedge CLK_div1) 
		begin
        left_reg <= left;
        right_reg <= right;
        left_reg_delay <= left_reg;
        right_reg_delay <= right_reg;
		end
	
	// 移動邏輯
    wire left_pressed = left_reg && !left_reg_delay;    // 確認按下瞬間
    wire right_pressed = right_reg && !right_reg_delay; // 確認按下瞬間	
	
	always @(posedge CLK_div) 
		  begin
			if(cnt >=7)
				cnt <= 0;
			else 
			   cnt <= cnt + 1;
			S <= {1'b1,cnt}; 			
			if(x==2) DATA_B <= B2_Char[cnt]; 
			else if(x==0) 
			   DATA_B <= B0_Char[cnt];
			else if(x==1) 
			   DATA_B <= B1_Char[cnt];
			else if(x==3) 
			   DATA_B <= B3_Char[cnt];
			else if(x==4) 
			   DATA_B <= B4_Char[cnt];
			else if(x==5) 
			   DATA_B <= B5_Char[cnt];
			 end	
				
	/*移動接盤*/
	always@(posedge CLK_div1, posedge Clear)
		begin 
			if(Clear)//初始位置
				begin
					x<=3'b010;
				end
			else if (left_pressed)
				begin
					if(x!=0)//最左邊
						x<=x-1'b1;
				end
			else if (right_pressed)
				begin
					if(x!=5)//最右邊
						x<=x+1'b1;
				end	
		end	
endmodule	

/*綠色硬幣*/
module greencoin(output reg [7:0]DATA_G, output reg [2:0]S,input CLK_div2, CLK_div3,Clear);
	reg[24:0]random;
   reg restart;
	
	always @(posedge CLK_div3,posedge Clear) 
		begin
			if (Clear) 
				begin
					random <= 25'd0;
				end	
			else if(random > 1000000)
				random <= 25'd0; 		
			else
		     random <= random + 1'b1;
		end
	
	initial
	begin
		DATA_G = 8'b10000000;
		S =random%8;
      restart = 0;
	end
	
	always @(posedge CLK_div2)
		begin
				if(restart)
					begin
						DATA_G <= 8'b00000001;	
						S <=random%8;
						restart = 0;
					end
			   else
					begin
						DATA_G = DATA_G << 1;
						if(DATA_G == 8'b0000000)
						begin
							restart = 1;
						end
					end
				
		end
endmodule

/*紅色硬幣*/
module redcoin(output reg [7:0]DATA_R, output reg [2:0]S,input CLK_div4, CLK_div5,Clear);
	reg[24:0]random;
   reg restart;
	
	always @(posedge CLK_div5,posedge Clear) 
		begin
			if (Clear) 
				begin
					random <= 25'd0;
				end	
			else if(random > 1000000)
				random <= 25'd0; 		
			else
		     random <= random + 1'b1;
		end
	
	initial
	begin
		DATA_R = 8'b10000000;
		S =random%8;
      restart = 0;
	end
	
	always @(posedge CLK_div4)
		begin
				if(restart)
					begin
						DATA_R <= 8'b00000001;	
						S <=random%8;
						restart = 0;
					end
			   else
					begin
						DATA_R = DATA_R << 1;
						if(DATA_R == 8'b00000000)
						begin
							restart = 1;
						end
					end
				
		end
endmodule
												 
/*接盤的除頻器*/
module divfreq(input CLK, output reg CLK_div);
	reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>25000)
				begin
					count<=25'b0;
					CLK_div<=~CLK_div;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*移動接盤的除頻器*/
module divfreq_1(input CLK, output reg CLK_div1);
	reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>250000)
				begin
					count<=25'b0;
					CLK_div1<=~CLK_div1;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*綠色硬幣的除頻器2HZ*/
module divfreq_2(input CLK, output reg CLK_div2);
	reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>12500000)
				begin
					count<=25'b0;
					CLK_div2<=~CLK_div2;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*綠色硬幣隨機位置的除頻器*/
module divfreq_3(input CLK, output reg CLK_div3);
	reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>785625)
				begin
					count<=25'b0;
					CLK_div3<=~CLK_div3;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*紅色硬幣的除頻器4HZ*/
module divfreq_4(input CLK, output reg CLK_div4);
	reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>6250000)
				begin
					count<=25'b0;
					CLK_div4<=~CLK_div4;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*紅色硬幣隨機位置的除頻器*/
module divfreq_5(input CLK, output reg CLK_div5);
reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>158746)
				begin
					count<=25'b0;
					CLK_div5<=~CLK_div5;
				end
			else
			count<=count + 1'b1;
			end
endmodule

/*遊戲畫面顯示的除頻器*/
module divfreq_6(input CLK, output reg CLK_div6);
reg[24:0]count;
	always@(posedge CLK)
		begin
			if(count>1000)
				begin
					count<=25'b0;
					CLK_div6<=~CLK_div6;
				end
			else
			count<=count + 1'b1;
			end
endmodule
