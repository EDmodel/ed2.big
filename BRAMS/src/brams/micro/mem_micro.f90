!############################# Change Log ##################################
! 5.0.0
!
!###########################################################################
!  Copyright (C)  1990, 1995, 1999, 2000, 2003 - All Rights Reserved
!  Regional Atmospheric Modeling System - RAMS
!###########################################################################


module mem_micro
   
   type micro_vars
   
      ! Variables to be dimensioned by (nzp,nxp,nyp)
   real, pointer, dimension(:,:,:) :: &
                          rcp,rrp,rpp,rsp,rap,rgp,rhp &
                         ,ccp,crp,cpp,csp,cap,cgp,chp &
                         ,cccnp,cifnp,q2,q6,q7

      ! Variables to be dimensioned by (nnxp,nyp)
   real, pointer, dimension(:,:) :: &
                          accpr,accpp,accps,accpa,accpg,accph &
                         ,pcprr,pcprp,pcprs,pcpra,pcprg,pcprh &
                         ,pcpg,qpcpg,dpcpg                    &
                         ,mean_pcpg,mean_qpcpg,mean_dpcpg 
                          
   end type               
                          
   type (micro_vars), allocatable :: micro_g(:), microm_g(:)
                          
contains                  
                          
  subroutine alloc_micro(micro,n1,n2,n3,ng,isfcl)

    use micphys

    implicit none          
    type (micro_vars) :: micro
    integer, intent(in) :: n1,n2,n3,ng,isfcl

    ! Allocate arrays based on options (if necessary)

    if (level >= 2 ) then
       allocate (micro%rcp(n1,n2,n3))
    endif
    if (level >= 3) then
       if(irain >= 1)  then
          allocate (micro%rrp(n1,n2,n3))
          allocate (micro%accpr(n2,n3))
          allocate (micro%pcprr(n2,n3))
          allocate (micro%q2(n1,n2,n3))
       endif
       if(ipris >= 1)  then
          allocate (micro%rpp(n1,n2,n3))
          allocate (micro%accpp(n2,n3))
          allocate (micro%pcprp(n2,n3))
       endif
       if(isnow >= 1)  then
          allocate (micro%rsp(n1,n2,n3))
          allocate (micro%accps(n2,n3))
          allocate (micro%pcprs(n2,n3))
       endif
       if(iaggr >= 1)  then
          allocate (micro%rap(n1,n2,n3))
          allocate (micro%accpa(n2,n3))
          allocate (micro%pcpra(n2,n3))
       endif
       if(igraup >= 1) then
          allocate (micro%rgp(n1,n2,n3))
          allocate (micro%accpg(n2,n3))
          allocate (micro%pcprg(n2,n3))
          allocate (micro%q6(n1,n2,n3))
       endif
       if(ihail >= 1)  then
          allocate (micro%rhp(n1,n2,n3))
          allocate (micro%accph(n2,n3))
          allocate (micro%pcprh(n2,n3))
          allocate (micro%q7(n1,n2,n3))
       endif
       if(icloud == 5) allocate (micro%ccp(n1,n2,n3))
       if(irain == 5)  allocate (micro%crp(n1,n2,n3))
       if(ipris == 5)  allocate (micro%cpp(n1,n2,n3))
       if(isnow == 5)  allocate (micro%csp(n1,n2,n3))
       if(iaggr == 5)  allocate (micro%cap(n1,n2,n3))
       if(igraup == 5) allocate (micro%cgp(n1,n2,n3))
       if(ihail == 5)  allocate (micro%chp(n1,n2,n3))
       ! *************Prob.in NEC SX-6
       ! * 240 Subscript error  array=cccnp size=1 subscript=4 eln=155
       ! PROG=initlz ELN=155(400940320)
       !IF(icloud == 7) ALLOCATE (micro%cccnp(n1,n2,n3))
       allocate (micro%cccnp(n1,n2,n3))
       ! * 240 Subscript error  array=cifnp size=1 subscript=4 eln=155
       ! PROG=initlz ELN=155(40094081c)
       !IF(ipris == 7)  ALLOCATE (micro%cifnp(n1,n2,n3))
       allocate (micro%cifnp(n1,n2,n3))

       allocate (micro%pcpg(n2,n3))
       allocate (micro%qpcpg(n2,n3))
       allocate (micro%dpcpg(n2,n3))
       
       ! Needed for ED
       if (isfcl == 5) then
         allocate (micro%mean_pcpg(n2,n3))
         allocate (micro%mean_qpcpg(n2,n3))
         allocate (micro%mean_dpcpg(n2,n3))
         ! Setting it to zero
         micro%mean_pcpg  = 0.0
         micro%mean_qpcpg = 0.0
         micro%mean_dpcpg = 0.0
       end if
    endif

    return
  end subroutine alloc_micro


   subroutine nullify_micro(micro)

   implicit none
   type (micro_vars) :: micro
   
   if (associated(micro%rcp))          nullify (micro%rcp)
   if (associated(micro%rrp))          nullify (micro%rrp)
   if (associated(micro%rpp))          nullify (micro%rpp)
   if (associated(micro%rsp))          nullify (micro%rsp)
   if (associated(micro%rap))          nullify (micro%rap)
   if (associated(micro%rgp))          nullify (micro%rgp)
   if (associated(micro%rhp))          nullify (micro%rhp)
   if (associated(micro%ccp))          nullify (micro%ccp)
   if (associated(micro%crp))          nullify (micro%crp)
   if (associated(micro%cpp))          nullify (micro%cpp)
   if (associated(micro%csp))          nullify (micro%csp)
   if (associated(micro%cap))          nullify (micro%cap)
   if (associated(micro%cgp))          nullify (micro%cgp)
   if (associated(micro%chp))          nullify (micro%chp)
   if (associated(micro%cccnp))        nullify (micro%cccnp)
   if (associated(micro%cifnp))        nullify (micro%cifnp)
   if (associated(micro%q2))           nullify (micro%q2)
   if (associated(micro%q6))           nullify (micro%q6)
   if (associated(micro%q7))           nullify (micro%q7)

   if (associated(micro%accpr))        nullify (micro%accpr)
   if (associated(micro%accpp))        nullify (micro%accpp)
   if (associated(micro%accps))        nullify (micro%accps)
   if (associated(micro%accpa))        nullify (micro%accpa)
   if (associated(micro%accpg))        nullify (micro%accpg)
   if (associated(micro%accph))        nullify (micro%accph)
   if (associated(micro%pcprr))        nullify (micro%pcprr)
   if (associated(micro%pcprp))        nullify (micro%pcprp)
   if (associated(micro%pcprs))        nullify (micro%pcprs)
   if (associated(micro%pcpra))        nullify (micro%pcpra)
   if (associated(micro%pcprg))        nullify (micro%pcprg)
   if (associated(micro%pcprh))        nullify (micro%pcprh)
   if (associated(micro%pcpg))         nullify (micro%pcpg)
   if (associated(micro%qpcpg))        nullify (micro%qpcpg)
   if (associated(micro%dpcpg))        nullify (micro%dpcpg)

   if (associated(micro%mean_pcpg))    nullify (micro%mean_pcpg)
   if (associated(micro%mean_qpcpg))   nullify (micro%mean_qpcpg)
   if (associated(micro%mean_dpcpg))   nullify (micro%mean_dpcpg)

   return
   end subroutine

   subroutine dealloc_micro(micro)

   implicit none
   type (micro_vars) :: micro
   
   if (associated(micro%rcp))          deallocate (micro%rcp)
   if (associated(micro%rrp))          deallocate (micro%rrp)
   if (associated(micro%rpp))          deallocate (micro%rpp)
   if (associated(micro%rsp))          deallocate (micro%rsp)
   if (associated(micro%rap))          deallocate (micro%rap)
   if (associated(micro%rgp))          deallocate (micro%rgp)
   if (associated(micro%rhp))          deallocate (micro%rhp)
   if (associated(micro%ccp))          deallocate (micro%ccp)
   if (associated(micro%crp))          deallocate (micro%crp)
   if (associated(micro%cpp))          deallocate (micro%cpp)
   if (associated(micro%csp))          deallocate (micro%csp)
   if (associated(micro%cap))          deallocate (micro%cap)
   if (associated(micro%cgp))          deallocate (micro%cgp)
   if (associated(micro%chp))          deallocate (micro%chp)
   if (associated(micro%cccnp))        deallocate (micro%cccnp)
   if (associated(micro%cifnp))        deallocate (micro%cifnp)
   if (associated(micro%q2))           deallocate (micro%q2)
   if (associated(micro%q6))           deallocate (micro%q6)
   if (associated(micro%q7))           deallocate (micro%q7)

   if (associated(micro%accpr))        deallocate (micro%accpr)
   if (associated(micro%accpp))        deallocate (micro%accpp)
   if (associated(micro%accps))        deallocate (micro%accps)
   if (associated(micro%accpa))        deallocate (micro%accpa)
   if (associated(micro%accpg))        deallocate (micro%accpg)
   if (associated(micro%accph))        deallocate (micro%accph)
   if (associated(micro%pcprr))        deallocate (micro%pcprr)
   if (associated(micro%pcprp))        deallocate (micro%pcprp)
   if (associated(micro%pcprs))        deallocate (micro%pcprs)
   if (associated(micro%pcpra))        deallocate (micro%pcpra)
   if (associated(micro%pcprg))        deallocate (micro%pcprg)
   if (associated(micro%pcprh))        deallocate (micro%pcprh)
   if (associated(micro%pcpg))         deallocate (micro%pcpg)
   if (associated(micro%qpcpg))        deallocate (micro%qpcpg)
   if (associated(micro%dpcpg))        deallocate (micro%dpcpg)

   if (associated(micro%mean_pcpg))    deallocate (micro%mean_pcpg)
   if (associated(micro%mean_qpcpg))   deallocate (micro%mean_qpcpg)
   if (associated(micro%mean_dpcpg))   deallocate (micro%mean_dpcpg)

   return
   end subroutine


subroutine filltab_micro(micro,microm,imean,n1,n2,n3,ng)

use var_tables

   implicit none
   type (micro_vars) :: micro,microm
   integer, intent(in) :: imean,n1,n2,n3,ng
   integer :: npts
   real, pointer :: var,varm

! Fill pointers to arrays into variable tables

   npts=n1*n2*n3
   if (associated(micro%rcp))   &
      call vtables2 (micro%rcp(1,1,1),microm%rcp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RCP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rrp))   &
      call vtables2 (micro%rrp(1,1,1),microm%rrp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RRP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rpp))   &
      call vtables2 (micro%rpp(1,1,1),microm%rpp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RPP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rsp))   &
      call vtables2 (micro%rsp(1,1,1),microm%rsp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RSP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rap))   &
      call vtables2 (micro%rap(1,1,1),microm%rap(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RAP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rgp))   &
      call vtables2 (micro%rgp(1,1,1),microm%rgp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RGP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%rhp))   &
      call vtables2 (micro%rhp(1,1,1),microm%rhp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'RHP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%ccp))   &
      call vtables2 (micro%ccp(1,1,1),microm%ccp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CCP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%crp))   &
      call vtables2 (micro%crp(1,1,1),microm%crp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CRP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%cpp))   &
      call vtables2 (micro%cpp(1,1,1),microm%cpp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CPP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%csp))   &
      call vtables2 (micro%csp(1,1,1),microm%csp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CSP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%cap))   &
      call vtables2 (micro%cap(1,1,1),microm%cap(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CAP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%cgp))   &
      call vtables2 (micro%cgp(1,1,1),microm%cgp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CGP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%chp))   &
      call vtables2 (micro%chp(1,1,1),microm%chp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CHP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%cccnp)) &
      call vtables2 (micro%cccnp(1,1,1),microm%cccnp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CCCNP :3:hist:anal:mpti:mpt3:mpt1')
   if (associated(micro%cifnp)) &
      call vtables2 (micro%cifnp(1,1,1),microm%cifnp(1,1,1)  &
                 ,ng, npts, imean,  &
                 'CIFNP :3:hist:anal:mpti:mpt3:mpt1')

   if (associated(micro%q2))   &
      call vtables2 (micro%q2(1,1,1),microm%q2(1,1,1)  &
                 ,ng, npts, imean,  &
                 'Q2 :3:hist:anal:mpti:mpt3')
   if (associated(micro%q6)) &
      call vtables2 (micro%q6(1,1,1),microm%q6(1,1,1)  &
                 ,ng, npts, imean,  &
                 'Q6 :3:hist:anal:mpti:mpt3')
   if (associated(micro%q7)) &
      call vtables2 (micro%q7(1,1,1),microm%q7(1,1,1)  &
                 ,ng, npts, imean,  &
                 'Q7 :3:hist:anal:mpti:mpt3')
                 
   npts=n2*n3
   if (associated(micro%accpr)) &
      call vtables2 (micro%accpr(1,1),microm%accpr(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPR :2:hist:anal:mpti:mpt3')
   if (associated(micro%accpp)) &
      call vtables2 (micro%accpp(1,1),microm%accpp(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPP :2:hist:anal:mpti:mpt3')
   if (associated(micro%accps)) &
      call vtables2 (micro%accps(1,1),microm%accps(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPS :2:hist:anal:mpti:mpt3')
   if (associated(micro%accpa)) &
      call vtables2 (micro%accpa(1,1),microm%accpa(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPA :2:hist:anal:mpti:mpt3')
   if (associated(micro%accpg)) &
      call vtables2 (micro%accpg(1,1),microm%accpg(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPG :2:hist:anal:mpti:mpt3')
   if (associated(micro%accph)) &
      call vtables2 (micro%accph(1,1),microm%accph(1,1)  &
                 ,ng, npts, imean,  &
                 'ACCPH :2:hist:anal:mpti:mpt3')
   if (associated(micro%pcprr)) &
      call vtables2 (micro%pcprr(1,1),microm%pcprr(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRR :2:anal:mpt3')
   if (associated(micro%pcprp)) &
      call vtables2 (micro%pcprp(1,1),microm%pcprp(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRP :2:anal:mpt3')
   if (associated(micro%pcprs)) &
      call vtables2 (micro%pcprs(1,1),microm%pcprs(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRS :2:anal:mpt3')
   if (associated(micro%pcpra)) &
      call vtables2 (micro%pcpra(1,1),microm%pcpra(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRA :2:anal:mpt3')
   if (associated(micro%pcprg)) &
      call vtables2 (micro%pcprg(1,1),microm%pcprg(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRG :2:anal:mpt3')
   if (associated(micro%pcprh)) &
      call vtables2 (micro%pcprh(1,1),microm%pcprh(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPRH :2:anal:mpt3')
   if (associated(micro%pcpg)) &
      call vtables2 (micro%pcpg(1,1),microm%pcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'PCPG :2:hist:mpti:mpt3')
   if (associated(micro%qpcpg)) &
      call vtables2 (micro%qpcpg(1,1),microm%qpcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'QPCPG :2:hist:mpti:mpt3')
   if (associated(micro%dpcpg)) &
      call vtables2 (micro%dpcpg(1,1),microm%dpcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'DPCPG :2:hist:mpti:mpt3')
                 
   if (associated(micro%mean_pcpg)) &
      call vtables2 (micro%mean_pcpg(1,1),microm%mean_pcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'MEAN_PCPG :2:mpti:mpt3')
   if (associated(micro%mean_qpcpg)) &
      call vtables2 (micro%mean_qpcpg(1,1),microm%mean_qpcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'MEAN_QPCPG :2:mpti:mpt3')
   if (associated(micro%mean_dpcpg)) &
      call vtables2 (micro%mean_dpcpg(1,1),microm%mean_dpcpg(1,1)  &
                 ,ng, npts, imean,  &
                 'MEAN_DPCPG :2:mpti:mpt3')

   return
   end subroutine

end module mem_micro