interface axi #(
  
   // Number of AXI inputs (slave interfaces)
    parameter S_COUNT = 4,
    // Number of AXI outputs (master interfaces)
    parameter M_COUNT = 4,
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 32,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Width of ID signal
    parameter ID_WIDTH = 8,
    // Propagate awuser signal
    parameter AWUSER_ENABLE = 0,
    // Width of awuser signal
    parameter AWUSER_WIDTH = 1,
    // Propagate wuser signal
    parameter WUSER_ENABLE = 0,
    // Width of wuser signal
    parameter WUSER_WIDTH = 1,
    // Propagate buser signal
    parameter BUSER_ENABLE = 0,
    // Width of buser signal
    parameter BUSER_WIDTH = 1,
    // Propagate aruser signal
    parameter ARUSER_ENABLE = 0,
    // Width of aruser signal
    parameter ARUSER_WIDTH = 1,
    // Propagate ruser signal
    parameter RUSER_ENABLE = 0,
    // Width of ruser signal
    parameter RUSER_WIDTH = 1,
    // Propagate ID field
    parameter FORWARD_ID = 0,
    // Number of regions per master interface
    parameter M_REGIONS = 1,
    // Master interface base addresses
    // M_COUNT concatenated fields of M_REGIONS concatenated fields of ADDR_WIDTH bits
    // set to zero for default addressing based on M_ADDR_WIDTH
    parameter M_BASE_ADDR = 0,
    // Master interface address widths
    // M_COUNT concatenated fields of M_REGIONS concatenated fields of 32 bits
    parameter M_ADDR_WIDTH = {M_COUNT{{M_REGIONS{32'd24}}}},
    // Read connections between interfaces
    // M_COUNT concatenated fields of S_COUNT bits
    parameter M_CONNECT_READ = {M_COUNT{{S_COUNT{1'b1}}}},
    // Write connections between interfaces
    // M_COUNT concatenated fields of S_COUNT bits
    parameter M_CONNECT_WRITE = {M_COUNT{{S_COUNT{1'b1}}}},
    // Secure master (fail operations based on awprot/arprot)
    // M_COUNT bits
    parameter M_SECURE = {M_COUNT{1'b0}}
  )
  (input bit ACLK,ARESETn);
    /*
     * AXI slave interfaces
     */
    logic [S_COUNT*ID_WIDTH-1:0]     s_axi_awid,
    logic [S_COUNT*ADDR_WIDTH-1:0]   s_axi_awaddr,
    logic [S_COUNT*8-1:0]            s_axi_awlen,
    logic [S_COUNT*3-1:0]            s_axi_awsize,
    logic [S_COUNT*2-1:0]            s_axi_awburst,
    logic [S_COUNT-1:0]              s_axi_awlock,
    logic [S_COUNT*4-1:0]            s_axi_awcache,
    logic [S_COUNT*3-1:0]            s_axi_awprot,
    logic [S_COUNT*4-1:0]            s_axi_awqos,
    logic [S_COUNT*AWUSER_WIDTH-1:0] s_axi_awuser,
    logic [S_COUNT-1:0]              s_axi_awvalid,
    logic [S_COUNT-1:0]              s_axi_awready,
    logic [S_COUNT*DATA_WIDTH-1:0]   s_axi_wdata,
    logic [S_COUNT*STRB_WIDTH-1:0]   s_axi_wstrb,
    logic [S_COUNT-1:0]              s_axi_wlast,
    logic [S_COUNT*WUSER_WIDTH-1:0]  s_axi_wuser,
    logic [S_COUNT-1:0]              s_axi_wvalid,
    logic [S_COUNT-1:0]              s_axi_wready,
    logic [S_COUNT*ID_WIDTH-1:0]     s_axi_bid,
    logic [S_COUNT*2-1:0]            s_axi_bresp,
    logic [S_COUNT*BUSER_WIDTH-1:0]  s_axi_buser,
    logic [S_COUNT-1:0]              s_axi_bvalid,
    logic [S_COUNT-1:0]              s_axi_bready,
    logic [S_COUNT*ID_WIDTH-1:0]     s_axi_arid,
    logic [S_COUNT*ADDR_WIDTH-1:0]   s_axi_araddr,
    logic [S_COUNT*8-1:0]            s_axi_arlen,
    logic [S_COUNT*3-1:0]            s_axi_arsize,
    logic [S_COUNT*2-1:0]            s_axi_arburst,
    logic [S_COUNT-1:0]              s_axi_arlock,
    logic [S_COUNT*4-1:0]            s_axi_arcache,
    logic [S_COUNT*3-1:0]            s_axi_arprot,
    logic [S_COUNT*4-1:0]            s_axi_arqos,
    logic [S_COUNT*ARUSER_WIDTH-1:0] s_axi_aruser,
    logic [S_COUNT-1:0]              s_axi_arvalid,
    logic [S_COUNT-1:0]              s_axi_arready,
    logic [S_COUNT*ID_WIDTH-1:0]     s_axi_rid,
    logic [S_COUNT*DATA_WIDTH-1:0]   s_axi_rdata,
    logic [S_COUNT*2-1:0]            s_axi_rresp,
    logic [S_COUNT-1:0]              s_axi_rlast,
    logic[S_COUNT*RUSER_WIDTH-1:0]  s_axi_ruser,
    logic [S_COUNT-1:0]              s_axi_rvalid,
    logic [S_COUNT-1:0]              s_axi_rready,

    /*
     * AXI master interfaces
     */
    logic [M_COUNT*ID_WIDTH-1:0]     m_axi_awid,
    logic [M_COUNT*ADDR_WIDTH-1:0]   m_axi_awaddr,
    logic [M_COUNT*8-1:0]            m_axi_awlen,
    logic [M_COUNT*3-1:0]            m_axi_awsize,
    logic [M_COUNT*2-1:0]            m_axi_awburst,
    logic [M_COUNT-1:0]              m_axi_awlock,
    logic [M_COUNT*4-1:0]            m_axi_awcache,
    logic [M_COUNT*3-1:0]            m_axi_awprot,
    logic [M_COUNT*4-1:0]            m_axi_awqos,
    logic [M_COUNT*4-1:0]            m_axi_awregion,
    logic [M_COUNT*AWUSER_WIDTH-1:0] m_axi_awuser,
    logic [M_COUNT-1:0]              m_axi_awvalid,
    logic [M_COUNT-1:0]              m_axi_awready,
    logic [M_COUNT*DATA_WIDTH-1:0]   m_axi_wdata,
    logic [M_COUNT*STRB_WIDTH-1:0]   m_axi_wstrb,
    logic [M_COUNT-1:0]              m_axi_wlast,
    logic [M_COUNT*WUSER_WIDTH-1:0]  m_axi_wuser,
    logic [M_COUNT-1:0]              m_axi_wvalid,
    logic[M_COUNT-1:0]              m_axi_wready,
    logic[M_COUNT*ID_WIDTH-1:0]     m_axi_bid,
    logic[M_COUNT*2-1:0]            m_axi_bresp,
    logic[M_COUNT*BUSER_WIDTH-1:0]  m_axi_buser,
    logic[M_COUNT-1:0]              m_axi_bvalid,
    logic [M_COUNT-1:0]              m_axi_bready,
    logic [M_COUNT*ID_WIDTH-1:0]     m_axi_arid,
    logic [M_COUNT*ADDR_WIDTH-1:0]   m_axi_araddr,
    logic [M_COUNT*8-1:0]            m_axi_arlen,
    logic [M_COUNT*3-1:0]            m_axi_arsize,
    logic [M_COUNT*2-1:0]            m_axi_arburst,
    logic [M_COUNT-1:0]              m_axi_arlock,
    logic [M_COUNT*4-1:0]            m_axi_arcache,
    logic [M_COUNT*3-1:0]            m_axi_arprot,
    logic [M_COUNT*4-1:0]            m_axi_arqos,
    logic [M_COUNT*4-1:0]            m_axi_arregion,
    logic [M_COUNT*ARUSER_WIDTH-1:0] m_axi_aruser,
    logic [M_COUNT-1:0]              m_axi_arvalid,
    logic[M_COUNT-1:0]              m_axi_arready,
    logic[M_COUNT*ID_WIDTH-1:0]     m_axi_rid,
    logic[M_COUNT*DATA_WIDTH-1:0]   m_axi_rdata,
    logic[M_COUNT*2-1:0]            m_axi_rresp,
    logic[M_COUNT-1:0]              m_axi_rlast,
    logic[M_COUNT*RUSER_WIDTH-1:0]  m_axi_ruser,
    logic[M_COUNT-1:0]              m_axi_rvalid,
    logic [M_COUNT-1:0]              m_axi_rready



//--------------------------------------------------------------------------------------------
clocking m_drv @(posedge ACLK);
default input #1 output #1;
 
//write_address_channel
output s_axi_awid,s_axi_awaddr,s_axi_awlen,s_axi_awsize,s_axi_awburst,s_axi_awvalid,s_axi_awlock,s_axi_awcache,s_axi_awprot,s_axi_awqos,s_axi_awuser;
input s_axi_awready;

//write_data channel
output s_axi_wdata,s_axi_wlast,s_axi_wvalid,s_axi_wstrb,s_axi_wuser;
input s_axi_wready;

//write_response channel
input s_axi_bid,s_axi_bresp,s_axi_bvalid,s_axi_buser;
output s_axi_bready;
//read_address_channel
output s_axi_arid,s_axi_araddr,s_axi_arlen,s_axi_arsize,s_axi_arburst,s_axi_arvalid,s_axi_arlock,s_axi_arcache,s_axi_arprot,s_axi_arqos,s_axi_aruser;
input s_axi_arready;

//read_data/response channel
input s_axi_rid,s_axi_rdata,s_axi_rresp,s_axi_rlast,s_axi_rvalid,s_axi_ruser;
output s_axi_rready;

endclocking
//---------------------------------------------------------------------------------------------

clocking m_mon @(posedge ACLK);
default input #1 output #1;

//write_address_channel
input s_axi_awid,s_axi_awaddr,s_axi_awlen,s_axi_awsize,s_axi_awburst,s_axi_awvalid,s_axi_awlock,s_axi_awcache,s_axi_awprot,s_axi_awqos,s_axi_awuser;
input s_axi_awready;

//write_data channel
input s_axi_wdata,s_axi_wlast,s_axi_wvalid,s_axi_wstrb,s_axi_wuser;
input s_axi_wready;

//write_response channel
input s_axi_bid,s_axi_bresp,s_axi_bvalid,s_axi_buser;
input s_axi_bready;
//read_address_channel
input s_axi_arid,s_axi_araddr,s_axi_arlen,s_axi_arsize,s_axi_arburst,s_axi_arvalid,s_axi_arlock,s_axi_arcache,s_axi_arprot,s_axi_arqos,s_axi_aruser;
input s_axi_arready;

//read_data/response channel
input s_axi_rid,s_axi_rdata,s_axi_rresp,s_axi_rlast,s_axi_rvalid,s_axi_ruser;
output s_axi_rready;

endclocking

//---------------------------------------------------------------------------------------------

clocking s_drv @(posedge ACLK);
default input #1 output #1;

//write_address_channel
input m_axi_awid,m_axi_awaddr,m_axi_awlen,m_axi_awsize,m_axi_awburst,m_axi_awvalid,m_axi_awlock,m_axi_awcache,m_axi_awprot,m_axi_awqos,m_axi_awregion,m_axi_awuser;
output m_axi_awready;

//write_data channel
input m_axi_wdata,m_axi_wstrb,m_axi_wlast,m_axi_wvalid,m_axi_wuser;
output m_axi_wready;

//write_response channel
output m_axi_bid,m_axi_bresp,m_axi_bvalid,m_axi_buser;
input m_axi_bready;
//read_address_channel
input m_axi_arid,m_axi_araddr,m_axi_arlen,m_axi_arsize,m_axi_arburst,m_axi_arvalid,m_axi_arlock,m_axi_arcache,m_axi_arprot,m_axi_arqos,m_axi_arregion,m_axi_aruser;
output m_axi_arready;

//read_data/response channel
output m_axi_rid,m_axi_rdata,m_axi_rresp,m_axi_rlast,m_axi_rvalid,m_axi_ruser;
input m_axi_rready;

endclocking

//---------------------------------------------------------------------------------------------

clocking s_mon @(posedge ACLK);
default input #1 output #1;
  
//write_address_channel
input m_axi_awid,m_axi_awaddr,m_axi_awlen,m_axi_awsize,m_axi_awburst,m_axi_awvalid,m_axi_awlock,m_axi_awcache,m_axi_awprot,m_axi_awqos,m_axi_awregion,m_axi_awuser;
input m_axi_awready;

//write_data channel
input m_axi_wdata,m_axi_wstrb,m_axi_wlast,m_axi_wvalid,m_axi_wuser;
input m_axi_wready;

//write_response channel
input m_axi_bid,m_axi_bresp,m_axi_bvalid,m_axi_buser;
input m_axi_bready;
//read_address_channel
input m_axi_arid,m_axi_araddr,m_axi_arlen,m_axi_arsize,m_axi_arburst,m_axi_arvalid,m_axi_arlock,m_axi_arcache,m_axi_arprot,m_axi_arqos,m_axi_arregion,m_axi_aruser;
input m_axi_arready;

//read_data/response channel
input m_axi_rid,m_axi_rdata,m_axi_rresp,m_axi_rlast,m_axi_rvalid,m_axi_ruser;
input m_axi_rready;

endclocking

//---------------------------------------------------------------------------------------------


modport M_DRV(clocking m_drv,input ARESETn);
modport M_MON(clocking m_mon,input ARESETn);
modport S_DRV(clocking s_drv,input ARESETn);
modport S_MON(clocking s_mon,input ARESETn);


//----------------------------------------------------------------------------------------------
//------------------------ASSERTIONS------------------------------------------------------------
//----------------------------------------------------------------------------------------------
//___________________________________________________________________________________

property m_awready;
 @(posedge ACLK) m_axi_awvalid && ~m_axi_awready |=> ($stable(m_axi_awaddr) && $stable(m_axi_awlen) && $stable(m_axi_awsize) && $stable(m_axi_awburst) && $stable(m_axi_awvalid) && $stable(m_axi_awid)) until m_axi_awready[->1];
endproperty
property s_awready;
  @(posedge ACLK) s_axi_awvalid && ~s_axi_awready |=> ($stable(s_axi_awaddr) && $stable(s_axi_awlen) && $stable(s_axi_awsize) && $stable(s_axi_awburst) && $stable(s_axi_awvalid) && $stable(s_axi_awid)) until s_axi_awready[->1];
endproperty  

property s_arready;
  @(posedge ACLK) s_axi_arready && ~s_axi_arready |=> ($stable(s_axi_araddr) && $stable(s_axi_arlen) && $stable(s_axi_arsize) && $stable(s_axi_arburst) && $stable(s_axi_arvalid) &&  $stable(s_axi_arid)) until s_axi_arready[->1];
endproperty

property m_arready;
  @(posedge ACLK) m_axi_arready && ~m_axi_arready |=> ($stable(m_axi_araddr) && $stable(m_axi_arlen) && $stable(m_axi_arsize) && $stable(m_axi_arburst) && $stable(m_axi_arvalid) &&  $stable(m_axi_arid)) until m_axi_arready[->1];
endproperty

property m_wready;
  @(posedge ACLK) m_axi_wvalid && ~m_axi_wready |=> ($stable(m_axi_wdata) && $stable(m_axi_wlast) && $stable(m_axi_wstrb) && $stable(m_axi_wvalid) until m_axi_wready[->1];endproperty

property s_wready;
 @(posedge ACLK) s_axi_wvalid && ~s_axi_wready |=> ($stable(s_axi_wdata) && $stable(s_axi_wlast) && $stable(s_axi_wstrb) && $stable(s_axi_wvalid) until s_axi_wready[->1];
endproperty

property s_rready;
 @(posedge ACLK) s_axi_rvalid && ~s_axi_rready |=> ($stable(s_axi_rdata) && $stable(s_axi_rresp) && $stable(s_axi_rlast) && $stable(s_axi_rvalid) && $stable(s_axi_rid)) until s_axi_rready[->1];
endproperty
property m_rready;
  @(posedge ACLK) m_axi_rvalid && ~m_axi_rready |=> ($stable(m_axi_rdata) && $stable(m_axi_rresp) && $stable(m_axi_rlast) && $stable(m_axi_rvalid) && $stable(m_axi_rid)) until m_axi_rready[->1];endproperty                                                  

property bready;
 @(posedge ACLK) BVALID && ~BREADY |=> ($stable(BRESP) && $stable(BID) && $stable(BVALID)) until BREADY[->1];
endproperty

AwReady_m : cover property(m_awready);
AwReady_s : cover property(s_awready);
ArReady_m : cover property(m_arready);
ArReady_s : cover property(s_arready);

wReady_m : cover property(m_wready);
wReady_s : cover property(m_wready);

rReady_m : cover property(m_rready);
rReady_s : cover property(s_rready);

bReady_m : cover property(m_bready);
bReady_s : cover property(s_bready);


//___________________________________________________________________________________
property size_1(x,y,z);
	@(posedge ACLK) (x==1) && (y==2) |-> z%2==0;
endproperty
property size_2(x,y,z);
	@(posedge ACLK) (x==2) && (y==2) |-> z%4==0;
endproperty

ASIZE_1: assert property(size_1(AWSIZE,AWBURST,AWADDR));
ASIZE_2: assert property(size_2(AWSIZE,AWBURST,AWADDR));
RSIZE_1: assert property(size_1(ARSIZE,ARBURST,ARADDR));
RSIZE_2: assert property(size_2(ARSIZE,ARBURST,ARADDR));
//___________________________________________________________________________________

/*
property a_size_1;
	@(posedge ACLK) (AWSIZE==1) && (AWBURST==2) |-> AWADDR%2==0;
endproperty
property a_size_2;
	@(posedge ACLK) (AWSIZE==2) && (AWBURST==2) |-> AWADDR%4==0;
endproperty
property r_size_1;
	@(posedge ACLK) (ARSIZE==1) && (ARBURST==2) |-> ARADDR%2==0;
endproperty
property r_size_2;
	@(posedge ACLK) (ARSIZE==1) && (ARBURST==2) |-> ARADDR%4==0;
endproperty
ASIZE_0: assert property(a_size_1);
ASIZE_1: assert property(a_size_2);
RSIZE_0: assert property(r_size_1);
RSIZE_1: assert property(r_size_2);
*/
//___________________________________________________________________________________

property a_len;
	@(posedge ACLK) $rose(AWVALID) && AWBURST==2 |-> AWLEN inside{1,3,7,15};
endproperty
property r_len;
	@(posedge ACLK) $rose(ARVALID) && ARBURST==2 |-> ARLEN inside{1,3,7,15};
endproperty

ALEN : cover property(a_len);
RLEN : cover property(r_len); 


//___________________________________________________________________________________

property a_size;
@(posedge ACLK) $rose(AWVALID) |-> AWSIZE inside{0,1,2};
endproperty
property r_size;
@(posedge ACLK) $rose(ARVALID) |-> ARSIZE inside{0,1,2};
endproperty

ASIZE : cover property(a_size);
RSIZE : cover property(r_size);

//___________________________________________________________________________________

property a_burst;
@(posedge ACLK) $rose(AWVALID) |-> AWBURST!==3;
endproperty

property r_burst;
@(posedge ACLK) $rose(ARVALID) |-> ARBURST!==3;
endproperty

ABURST: cover property(a_burst);
RBURST: cover property(r_burst);
//___________________________________________________________________________________
  



/*
property awvalid;
@(posedge ACLK) AWVALID |-> if(AWREADY)
					(##1 ~AWVALID || AWVALID)
				else
					(##1 $stable(AWVALID));
endproperty
property wvalid;
@(posedge ACLK) WVALID |-> if(WREADY)
					(##1 ~WVALID || WVALID)
				else
					(##1 $stable(WVALID));
endproperty
property arvalid;
@(posedge ACLK) ARVALID |-> if(ARREADY)
					(##1 ~ARVALID || ARVALID)
				else
					(##1 $stable(ARVALID));

endproperty
property rvalid;
@(posedge ACLK) RVALID |-> if(RREADY)
					(##1 ~RVALID || RVALID)
				else
					(##1 $stable(RVALID));
endproperty
property bvalid;
@(posedge ACLK) BVALID |-> if(BREADY)
					(##1 BVALID || !BVALID)	  
				else
				(##1 $stable(BVALID));
endproperty

Awvalid : assert property(awvalid);
Wvalid : assert property(wvalid);
Arvalid : assert property(arvalid);
Rvalid : assert property(rvalid);
Bvalid : assert property(bvalid);
*/
/*property awvalid;
@(posedge ACLK) AWVALID && ~AWREADY |=> $stable(AWVALID) intersect ~AWREADY;
endproperty
property wvalid;
@(posedge ACLK) WVALID && ~WREADY |=> $stable(WVALID) intersect ~WREADY;
endproperty
property arvalid;
@(posedge ACLK) ARVALID && ~ARREADY |=> $stable(ARVALID) intersect ~ARREADY;
endproperty
property rvalid;
@(posedge ACLK) RVALID && ~RREADY |=> $stable(RVALID) intersect ~RREADY;
endproperty
property bvalid;
@(posedge ACLK) BVALID && ~BREADY |=> $stable(BVALID) intersect ~BREADY;
endproperty

Awvalid : cover property(awvalid);
Wvalid : cover property(wvalid);
Arvalid : cover property(arvalid);
Rvalid : cover property(rvalid);
Bvalid : cover property(bvalid);*/
endinterface
