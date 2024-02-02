#ifndef _ALICE_FF_H_
#define _ALICE_FF_H_

#define BPLCON0_FF\
    nullptr,\
    &top->Alice_tb->DUT->BPLCON0_LB1->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB2->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB3->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB4->_r_D_phi2,\
    nullptr,\
    &top->Alice_tb->DUT->BPLCON0_LB6->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    &top->Alice_tb->DUT->BPLCON0_LB12->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB13->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB14->_r_D_phi2,\
    &top->Alice_tb->DUT->BPLCON0_LB15->_r_D_phi2

#define DDFSTRT_FF\
    nullptr,\
    &top->Alice_tb->DUT->DFS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->DFS_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define DDFSTOP_FF\
    nullptr,\
    &top->Alice_tb->DUT->DFC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->DFC_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define DIWSTRT_FF\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    &top->Alice_tb->DUT->DWS_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP7->_r_D_phi2

#define DIWSTOP_FF\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    &top->Alice_tb->DUT->DWC_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP7->_r_D_phi2

#define DIWHIGH_FF\
    &top->Alice_tb->DUT->DWS_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->DWS_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    &top->Alice_tb->DUT->DWC_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->DWC_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,

#define BEAMCON0_FF\
    &top->Alice_tb->DUT->BEAMCON0_LB0->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB1->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB2->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB3->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB4->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB5->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB6->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB7->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB8->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB9->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB10->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB11->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB12->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB13->_r_D_phi2,\
    &top->Alice_tb->DUT->BEAMCON0_LB14->_r_D_phi2,\
    nullptr

#define HBSTRT_FF\
    &top->Alice_tb->DUT->HBS_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HBS_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define HBSTOP_FF\
    &top->Alice_tb->DUT->HBC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HBC_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define HSSTRT_FF\
    &top->Alice_tb->DUT->HSS_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HSS_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define HSSTOP_FF\
    &top->Alice_tb->DUT->HSC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HSC_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define HCENTER_FF\
    &top->Alice_tb->DUT->HC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HC_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define HTOTAL_FF\
    &top->Alice_tb->DUT->HT_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->HT_CMP8->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define VBSTRT_FF\
    &top->Alice_tb->DUT->VBS_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->VBS_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define VBSTOP_FF\
    &top->Alice_tb->DUT->VBC_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->VBC_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define VSSTRT_FF\
    &top->Alice_tb->DUT->VSS_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->VSS_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define VSSTOP_FF\
    &top->Alice_tb->DUT->VSC_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->VSC_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define VTOTAL_FF\
    &top->Alice_tb->DUT->VT_CMP0->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP1->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP2->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP3->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP4->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP5->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP6->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP7->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP8->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP9->_r_D_phi2,\
    &top->Alice_tb->DUT->VT_CMP10->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

#define FMODE_FF\
    &top->Alice_tb->DUT->FMODE_LD0->_r_D_phi2,\
    &top->Alice_tb->DUT->FMODE_LD1->_r_D_phi2,\
    &top->Alice_tb->DUT->FMODE_LD2->_r_D_phi2,\
    &top->Alice_tb->DUT->FMODE_LD3->_r_D_phi2,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr,\
    nullptr

typedef struct
{
    vluint8_t *BPLCON0[16];
    vluint8_t *DDFSTRT[16];
    vluint8_t *DDFSTOP[16];
    vluint8_t *DIWSTRT[16];
    vluint8_t *DIWSTOP[16];
    vluint8_t *DIWHIGH[16];
    vluint8_t *BEAMCON0[16];
    vluint8_t *HBSTRT[16];
    vluint8_t *HBSTOP[16];
    vluint8_t *HSSTRT[16];
    vluint8_t *HSSTOP[16];
    vluint8_t *HCENTER[16];
    vluint8_t *HTOTAL[16];
    vluint8_t *VBSTRT[16];
    vluint8_t *VBSTOP[16];
    vluint8_t *VSSTRT[16];
    vluint8_t *VSSTOP[16];
    vluint8_t *VTOTAL[16];
    vluint8_t *FMODE[16];
} ff_ptr_t;

ff_ptr_t *reg_ctor(void);
void      reg_dtor(ff_ptr_t *reg);
void      reg_write(vluint8_t *p_u8[16], vluint16_t val);

#define REG_WRITE(name, value) reg_write(reg->name, value)

#endif /* _ALICE_FF_H_ */
