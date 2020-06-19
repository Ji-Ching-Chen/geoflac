! -*- F90 -*-
module params
implicit none

integer, parameter :: maxzone = 10   ! max nzonx and nzony
integer, parameter :: maxtrzone = 20   ! max nzone_marker and nzone_tracer
integer, parameter :: maxphasel = 20   ! max nphasl
integer, parameter :: maxbc = 20   ! max # of bcs
integer, parameter :: maxph = 20   ! max # of phases
integer, parameter :: maxinh = 50   ! max # of inhomogeneities

real*8, parameter :: sec_year = 3.1558d+7  ! seconds in a year


integer :: nx,nz,nq,nzonx,nzony,nelz_x(maxzone),nelz_y(maxzone), &
     ny_rem,mode_rem,ntest_rem,ivis_shape,igeotherm, &
     ny_inject,nelem_inject,nmass_update,nopbmax,iinj,nydrsides,nystressbc, &
     nofbc,nofside(maxbc),nbc1(maxbc),nbc2(maxbc),nbc(maxbc), &
     mix_strain,mix_stress,lastsave,lastout, &
     io_vel,io_srII,io_eII,io_aps,io_sII,io_sxx,io_szz, &
     io_sxz,io_pres,io_temp,io_phase,io_visc,io_unused,io_density, &
     io_src,io_diss,io_forc,io_hfl,io_topo, &
     irphase,irtemp,ircoord, &
     nphase,mphase,irheol(maxph), &
     ltop(maxphasel),lbottom(maxphasel),lphase(maxphasel), &
     imx1(maxtrzone),imx2(maxtrzone),imy1(maxtrzone),imy2(maxtrzone), &
     itx1(maxtrzone),itx2(maxtrzone),ity1(maxtrzone),ity2(maxtrzone), &
     nphasl,nzone_marker,nmarkers, iint_marker,iint_tracer,nzone_tracer, &
     ix1(maxinh),ix2(maxinh),iy1(maxinh),iy2(maxinh),inphase(maxinh), &
     igeom(maxinh),inhom, &
     itherm,istress_therm,initial_geoth,itemp_bc,ix1t,ix2t,iy1t,iy2t,ishearh, &
     ntherm,ixtb1(maxph),ixtb2(maxph),nzone_age,i_prestress, &
     iph_col1(maxph),iph_col2(maxph),iph_col3(maxph),iph_col4(maxph), &
     iph_col5(maxph),iph_col_trans(maxph), &
     if_intrus,if_hydro, &
     nyhydro,iphsub, &
     movegrid,ndim,ifreq_visc,nmtracers,i_rey, &
     iph_int,incoming_left,incoming_right, &
     iynts, iax1,iay1,ibx1,iby1,icx1,icy1,idx1,idy1, &
     ivis_present,n_boff_cutoff,idt_scale,ifreq_imasses,ifreq_rmasses, &
     nloop,ifreq_avgsr,nsrate

real*8 :: x0,z0,rxbo,rzbo,sizez_x(maxzone),sizez_y(maxzone), &
     dx_rem,angle_rem,anglemin1,anglemint,topo_kappa,fac_kappa, &
     velbc_l,velbc_r,v_min,v_max,efoldc, &
     g_x0,g_y0c,g_amplitude,g_width, &
     rate_inject,tbos, &
     bca(maxbc),bcb(maxbc),bcc(maxbc),xReyn, &
     bcd(maxbc),bce(maxbc),bcf(maxbc),bcg(maxbc),bch(maxbc),bci(maxbc), &
     dt_scale,strain_inert,vbc,amul,ratl,ratu,frac, &
     dtmax_therm,dt_maxwell,fracm,srate0, &
     dt_elastic,dt_elastic0,demf,boff, &
     dtout_screen,dtout_file,dtsave_file, &
     visc(maxph),den(maxph),alfa(maxph),beta(maxph),pln(maxph), &
     acoef(maxph),eactiv(maxph),rl(maxph),rm(maxph), &
     plstrain1(maxph),plstrain2(maxph),fric1(maxph),fric2(maxph), &
     cohesion1(maxph),cohesion2(maxph), &
     dilat1(maxph),dilat2(maxph), &
     conduct(maxph),cp(maxph), &
     ts(maxph),tl(maxph),tk(maxph),fk(maxph), &
     ten_off,tau_heal,dt_outtracer,xinitaps(maxinh), &
     t_top,t_bot,hs,hr,temp_per,bot_bc, &
     hc1(maxph),hc2(maxph),hc3(maxph),hc4(maxph), &
     age_1(maxph),g,pisos,drosub,damp_vis, &
     time,dt,time_max, dtavg


character phasefile*20,tempfile*20,coordfile*20

!$ACC declare copyin(nx,nz,nq,nzonx,nzony,nelz_x(maxzone),nelz_y(maxzone), &
!$ACC     ny_rem,mode_rem,ntest_rem,ivis_shape,igeotherm, &
!$ACC     ny_inject,nelem_inject,nmass_update,nopbmax,iinj,nydrsides,nystressbc, &
!$ACC     nofbc,nofside(maxbc),nbc1(maxbc),nbc2(maxbc),nbc(maxbc), &
!$ACC     mix_strain,mix_stress,lastsave,lastout, &
!$ACC     io_vel,io_srII,io_eII,io_aps,io_sII,io_sxx,io_szz, &
!$ACC     io_sxz,io_pres,io_temp,io_phase,io_visc,io_unused,io_density, &
!$ACC     io_src,io_diss,io_forc,io_hfl,io_topo, &
!$ACC     irphase,irtemp,ircoord, &
!$ACC     nphase,mphase,irheol(maxph), &
!$ACC     ltop(maxphasel),lbottom(maxphasel),lphase(maxphasel), &
!$ACC     imx1(maxtrzone),imx2(maxtrzone),imy1(maxtrzone),imy2(maxtrzone), &
!$ACC     itx1(maxtrzone),itx2(maxtrzone),ity1(maxtrzone),ity2(maxtrzone), &
!$ACC     nphasl,nzone_marker,nmarkers, iint_marker,iint_tracer,nzone_tracer, &
!$ACC     ix1(maxinh),ix2(maxinh),iy1(maxinh),iy2(maxinh),inphase(maxinh), &
!$ACC     igeom(maxinh),inhom, &
!$ACC     itherm,istress_therm,initial_geoth,itemp_bc,ix1t,ix2t,iy1t,iy2t,ishearh, &
!$ACC     ntherm,ixtb1(maxph),ixtb2(maxph),nzone_age,i_prestress, &
!$ACC     iph_col1(maxph),iph_col2(maxph),iph_col3(maxph),iph_col4(maxph), &
!$ACC     iph_col5(maxph),iph_col_trans(maxph), &
!$ACC     if_intrus,if_hydro, &
!$ACC     nyhydro,iphsub, &
!$ACC     movegrid,ndim,ifreq_visc,nmtracers,i_rey, &
!$ACC     iph_int,incoming_left,incoming_right, &
!$ACC     iynts, iax1,iay1,ibx1,iby1,icx1,icy1,idx1,idy1, &
!$ACC     ivis_present,n_boff_cutoff,idt_scale,ifreq_imasses,ifreq_rmasses, &
!$ACC     nloop,ifreq_avgsr,nsrate)

!$ACC declare copyin(x0,z0,rxbo,rzbo,sizez_x(maxzone),sizez_y(maxzone), &
!$ACC     dx_rem,angle_rem,anglemin1,anglemint,topo_kappa,fac_kappa, &
!$ACC     velbc_l,velbc_r,v_min,v_max,efoldc, &
!$ACC     g_x0,g_y0c,g_amplitude,g_width, &
!$ACC     rate_inject,tbos, &
!$ACC     bca(maxbc),bcb(maxbc),bcc(maxbc),xReyn, &
!$ACC     bcd(maxbc),bce(maxbc),bcf(maxbc),bcg(maxbc),bch(maxbc),bci(maxbc), &
!$ACC     dt_scale,strain_inert,vbc,amul,ratl,ratu,frac, &
!$ACC     dtmax_therm,dt_maxwell,fracm,srate0, &
!$ACC     dt_elastic,dt_elastic0,demf,boff, &
!$ACC     dtout_screen,dtout_file,dtsave_file, &
!$ACC     visc(maxph),den(maxph),alfa(maxph),beta(maxph),pln(maxph), &
!$ACC     acoef(maxph),eactiv(maxph),rl(maxph),rm(maxph), &
!$ACC     plstrain1(maxph),plstrain2(maxph),fric1(maxph),fric2(maxph), &
!$ACC     cohesion1(maxph),cohesion2(maxph), &
!$ACC     dilat1(maxph),dilat2(maxph), &
!$ACC     conduct(maxph),cp(maxph), &
!$ACC     ts(maxph),tl(maxph),tk(maxph),fk(maxph), &
!$ACC     ten_off,tau_heal,dt_outtracer,xinitaps(maxinh), &
!$ACC     t_top,t_bot,hs,hr,temp_per,bot_bc, &
!$ACC     hc1(maxph),hc2(maxph),hc3(maxph),hc4(maxph), &
!$ACC     age_1(maxph),g,pisos,drosub,damp_vis, &
!$ACC     time,dt,time_max, dtavg)
end module params
