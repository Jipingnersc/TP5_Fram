      module mod_mean
      implicit none
c
c --- HYCOM mean: array allocation and calculation interface.
c
c --- ii    = 1st dimension of array (==idm)
c --- jj    = 2nd dimension of array (==jdm)
c --- kk    = number of layers (typically 1)
c --- nmean = number of archive records in the mean
c
      integer, save :: ii,ii1,ii2,iorign,jj,jj1,jj2,jorign,kk
      integer, save :: nmean,nstep
c
c --- archive header
c
      character, save :: ctitle(4)*80
c
c --- arrays:
c
      real,    save, allocatable, dimension (:,:,:) :: 
     &   u,v,ke,temp,saln,th3d,dp,dw,p,tracer,
     &   u_m,v_m,ke_m,temp_m,saln_m,th3d_m,dp_m,dw_m,tracer_m
c
      real,    save, allocatable, dimension (:,:)   :: 
     &   depths,depthu,depthv,
     &   ubaro,vbaro,pbaro,kebaro,
     &   montg,srfht,dpbl,dpmixl,
     &   tmix,smix,thmix,umix,vmix,kemix,
     &   surflx,salflx, covice,thkice,temice,
     &   ubaro_m,vbaro_m,pbaro_m,kebaro_m,
     &   montg_m,srfht_m,dpbl_m,dpmixl_m,
     &   tmix_m,smix_m,thmix_m,umix_m,vmix_m,kemix_m,
     &   surflx_m,salflx_m, covice_m,thkice_m,temice_m
c
      real,    save, allocatable, dimension (:)     :: 
     &   theta
c
      integer, save, allocatable, dimension (:,:)   ::
     &   ip,iq,iu,iv
c
c --- module subroutines
c
      contains


      subroutine mean_alloc
      implicit none
c
c --- initialize allocatable arrays.
c
      ii1 = ii - 1
      ii2 = ii - 2
      jj1 = jj - 1
      jj2 = jj - 2
c
      nmean = 0
c
      allocate(      u(ii,jj,kk) )
      allocate(      v(ii,jj,kk) )
      allocate(     ke(ii,jj,kk) )
      allocate(   temp(ii,jj,kk) )
      allocate(   saln(ii,jj,kk) )
      allocate(   th3d(ii,jj,kk) )
      allocate(     dp(ii,jj,kk) )
      allocate(     dw(ii,jj,kk) )
      allocate(      p(ii,jj,kk+1) )
      allocate( tracer(ii,jj,kk) )
c
      allocate(      u_m(ii,jj,kk) );        u_m = 0.0
      allocate(      v_m(ii,jj,kk) );        v_m = 0.0
      allocate(     ke_m(ii,jj,kk) );       ke_m = 0.0
      allocate(   temp_m(ii,jj,kk) );     temp_m = 0.0
      allocate(   saln_m(ii,jj,kk) );     saln_m = 0.0
      allocate(   th3d_m(ii,jj,kk) );     th3d_m = 0.0
      allocate(     dp_m(ii,jj,kk) );       dp_m = 0.0
      allocate(     dw_m(ii,jj,kk) );       dw_m = 0.0
      allocate( tracer_m(ii,jj,kk) );   tracer_m = 0.0
c
      allocate( depths(0:ii,0:jj) )
c
      allocate( depthu(ii,jj) )
      allocate( depthv(ii,jj) )
      allocate(  ubaro(ii,jj) )
      allocate(  vbaro(ii,jj) )
      allocate(  pbaro(ii,jj) )
      allocate( kebaro(ii,jj) )
      allocate(  montg(ii,jj) )
      allocate(  srfht(ii,jj) )
      allocate(   dpbl(ii,jj) )
      allocate( dpmixl(ii,jj) )
      allocate(   tmix(ii,jj) )
      allocate(   smix(ii,jj) )
      allocate(  thmix(ii,jj) )
      allocate(   umix(ii,jj) )
      allocate(   vmix(ii,jj) )
      allocate(  kemix(ii,jj) )
      allocate( surflx(ii,jj) )
      allocate( salflx(ii,jj) )
      allocate( covice(ii,jj) )
      allocate( thkice(ii,jj) )
      allocate( temice(ii,jj) )
c
      allocate(  ubaro_m(ii,jj) );    ubaro_m = 0.0
      allocate(  vbaro_m(ii,jj) );    vbaro_m = 0.0
      allocate(  pbaro_m(ii,jj) );    pbaro_m = 0.0
      allocate( kebaro_m(ii,jj) );   kebaro_m = 0.0
      allocate(  montg_m(ii,jj) );    montg_m = 0.0
      allocate(  srfht_m(ii,jj) );    srfht_m = 0.0
      allocate(   dpbl_m(ii,jj) );     dpbl_m = 0.0
      allocate( dpmixl_m(ii,jj) );   dpmixl_m = 0.0
      allocate(   tmix_m(ii,jj) );     tmix_m = 0.0
      allocate(   smix_m(ii,jj) );     smix_m = 0.0
      allocate(  thmix_m(ii,jj) );    thmix_m = 0.0
      allocate(   umix_m(ii,jj) );     umix_m = 0.0
      allocate(   vmix_m(ii,jj) );     vmix_m = 0.0
      allocate(  kemix_m(ii,jj) );    kemix_m = 0.0
      allocate( surflx_m(ii,jj) );   surflx_m = 0.0
      allocate( salflx_m(ii,jj) );   salflx_m = 0.0
      allocate( covice_m(ii,jj) );   covice_m = 0.0
      allocate( thkice_m(ii,jj) );   thkice_m = 0.0
      allocate( temice_m(ii,jj) );   temice_m = 0.0
c
      allocate(     ip(ii,jj) )
      allocate(     iq(ii,jj) )
      allocate(     iu(ii,jj) )
      allocate(     iv(ii,jj) )
c
      allocate(  theta(kk) )
*
*     write(6,*) 'mean_alloc -    dp_m = ',   dp_m(54, 1,1)
*


      end subroutine mean_alloc


      subroutine mean_add(iweight)
      implicit none
c
      integer, intent(in) :: iweight
c
c --- add an archive to the mean.
c --- layer quantities weighted by layer thickness (i.e. by dw).
c
      integer i,im,j,jm,k
      real    s,swk,sw(kk)
c
      nmean = nmean + iweight
c
      s = iweight
c
      do j= 1,jj
        do i= 1,ii
          if     (ip(i,j).eq.1) then
            p(i,j,1) = 0.0
            do k= 1,kk
              p(i,j,k+1) = p(i,j,k) + dw(i,j,k)
            enddo
          else
            p(i,j,:) = 0.0
          endif
        enddo
      enddo
c
      do j= 1,jj
        do i= 1,ii
          if     (iu(i,j).eq.1) then
            ubaro_m(i,j) =  ubaro_m(i,j) + ubaro(i,j) * s
             umix_m(i,j) =   umix_m(i,j) +  umix(i,j) * s
c
            if     (i.ne.1) then
              im = i-1
            else
              im = ii
            endif
            do k= 1,kk
              swk = s*max(0.0,
!!Alex     &                    min(depthu(i,j),
     &                        0.5*(p(i,j,k+1)+p(im,j,k+1)) -
!!Alex     &                    min(depthu(i,j),
     &                        0.5*(p(i,j,k  )+p(im,j,k  ))  )
              u_m(i,j,k) = u_m(i,j,k) + u(i,j,k) * swk
            enddo
          endif !iu


          if     (iv(i,j).eq.1) then
            vbaro_m(i,j) = vbaro_m(i,j) + vbaro(i,j) * s
             vmix_m(i,j) =  vmix_m(i,j) +  vmix(i,j) * s
c
            if     (j.ne.1) then
              jm = j-1
            else
              jm = jj
            endif
            do k= 1,kk
              swk = s*max(0.0,
!!Alex     &                    min(depthv(i,j),
     &                        0.5*(p(i,j,k+1)+p(i,jm,k+1)) -
!!Alex     &                    min(depthv(i,j),
     &                        0.5*(p(i,j,k  )+p(i,jm,k  ))  )
              v_m(i,j,k) = v_m(i,j,k) + v(i,j,k) * swk
            enddo
          endif !iv
c
          if     (ip(i,j).eq.1) then
             pbaro_m(i,j)   =  pbaro_m(i,j)   +  pbaro(i,j)   * s
            kebaro_m(i,j)   = kebaro_m(i,j)   + kebaro(i,j)   * s
             montg_m(i,j)   =  montg_m(i,j)   +  montg(i,j)   * s
             srfht_m(i,j)   =  srfht_m(i,j)   +  srfht(i,j)   * s
              dpbl_m(i,j)   =   dpbl_m(i,j)   +   dpbl(i,j)   * s
            dpmixl_m(i,j)   = dpmixl_m(i,j)   + dpmixl(i,j)   * s
              tmix_m(i,j)   =   tmix_m(i,j)   +   tmix(i,j)   * s
              smix_m(i,j)   =   smix_m(i,j)   +   smix(i,j)   * s
             thmix_m(i,j)   =  thmix_m(i,j)   +  thmix(i,j)   * s
             kemix_m(i,j)   =  kemix_m(i,j)   +  kemix(i,j)   * s
            surflx_m(i,j)   = surflx_m(i,j)   + surflx(i,j)   * s
            salflx_m(i,j)   = salflx_m(i,j)   + salflx(i,j)   * s
            covice_m(i,j)   = covice_m(i,j)   + covice(i,j)   * s
            thkice_m(i,j)   = thkice_m(i,j)   + thkice(i,j)   * s
            temice_m(i,j)   = temice_m(i,j)   + temice(i,j)   * s
c
                      sw(:) =                       dw(i,j,:) * s
c
                dw_m(i,j,:) =     dw_m(i,j,:) +                 sw(:)
                dp_m(i,j,:) =     dp_m(i,j,:) +                 sw(:)
              temp_m(i,j,:) =   temp_m(i,j,:) +   temp(i,j,:) * sw(:)
              saln_m(i,j,:) =   saln_m(i,j,:) +   saln(i,j,:) * sw(:)
              th3d_m(i,j,:) =   th3d_m(i,j,:) +   th3d(i,j,:) * sw(:)
                ke_m(i,j,:) =     ke_m(i,j,:) +     ke(i,j,:) * sw(:)
            tracer_m(i,j,:) = tracer_m(i,j,:) + tracer(i,j,:) * sw(:)
          endif !ip
        enddo
      enddo
*
*     write(6,*) 'mean_add   -    dp_m = ',   dp_m(54, 1,1),
*    &                                        dp(  54, 1,1)
*


      end subroutine mean_add


      subroutine mean_addsq(iweight)
      implicit none
c
      integer, intent(in) :: iweight
c
c --- add an archive sqaured to the mean.
c --- layer quantities weighted by layer thickness (i.e. by dw).
c
      integer i,im,j,jm,k
      real    s,swk,sw(kk)
c
      nmean = nmean + iweight
c
      s = iweight
c
      do j= 1,jj
        do i= 1,ii
          if     (ip(i,j).eq.1) then
            p(i,j,1) = 0.0
            do k= 1,kk
              p(i,j,k+1) = p(i,j,k) + dw(i,j,k)
            enddo
          else
            p(i,j,:) = 0.0
          endif
        enddo
      enddo
c
      do j= 1,jj
        do i= 1,ii
          if     (iu(i,j).eq.1) then
            ubaro_m(i,j) =  ubaro_m(i,j) + ubaro(i,j)**2 * s
             umix_m(i,j) =   umix_m(i,j) +  umix(i,j)**2 * s
c
            if     (i.ne.1) then
              im = i-1
            else
              im = ii
            endif
            do k= 1,kk
              swk = s*max(0.0,
     &                    min(depthu(i,j),
     &                        0.5*(p(i,j,k+1)+p(im,j,k+1))) -
     &                    min(depthu(i,j),
     &                        0.5*(p(i,j,k  )+p(im,j,k  )))  )
              u_m(i,j,k) = u_m(i,j,k) + u(i,j,k)**2 * swk
            enddo
          endif !iu
c
          if     (iv(i,j).eq.1) then
            vbaro_m(i,j) = vbaro_m(i,j) + vbaro(i,j)**2 * s
             vmix_m(i,j) =  vmix_m(i,j) +  vmix(i,j)**2 * s
c
            if     (j.ne.1) then
              jm = j-1
            else
              jm = jj
            endif
            do k= 1,kk
              swk = s*max(0.0,
     &                    min(depthv(i,j),
     &                        0.5*(p(i,j,k+1)+p(i,jm,k+1))) -
     &                    min(depthv(i,j),
     &                        0.5*(p(i,j,k  )+p(i,jm,k  )))  )
              v_m(i,j,k) = v_m(i,j,k) + v(i,j,k)**2 * swk
            enddo
          endif !iv
c
          if     (ip(i,j).eq.1) then
             pbaro_m(i,j)   =  pbaro_m(i,j)   +  pbaro(i,j)**2   * s
            kebaro_m(i,j)   = kebaro_m(i,j)   + kebaro(i,j)**2   * s
             montg_m(i,j)   =  montg_m(i,j)   +  montg(i,j)**2   * s
             srfht_m(i,j)   =  srfht_m(i,j)   +  srfht(i,j)**2   * s
              dpbl_m(i,j)   =   dpbl_m(i,j)   +   dpbl(i,j)**2   * s
            dpmixl_m(i,j)   = dpmixl_m(i,j)   + dpmixl(i,j)**2   * s
              tmix_m(i,j)   =   tmix_m(i,j)   +   tmix(i,j)**2   * s
              smix_m(i,j)   =   smix_m(i,j)   +   smix(i,j)**2   * s
             thmix_m(i,j)   =  thmix_m(i,j)   +  thmix(i,j)**2   * s
             kemix_m(i,j)   =  kemix_m(i,j)   +  kemix(i,j)**2   * s
            surflx_m(i,j)   = surflx_m(i,j)   + surflx(i,j)**2   * s
            salflx_m(i,j)   = salflx_m(i,j)   + salflx(i,j)**2   * s
            covice_m(i,j)   = covice_m(i,j)   + covice(i,j)**2   * s
            thkice_m(i,j)   = thkice_m(i,j)   + thkice(i,j)**2   * s
            temice_m(i,j)   = temice_m(i,j)   + temice(i,j)**2   * s
c
                      sw(:) =                       dw(i,j,:)    * s
c
                dw_m(i,j,:) =     dw_m(i,j,:) +                    sw(:)
                dp_m(i,j,:) =     dp_m(i,j,:) +     dp(i,j,:)**2 * s
              temp_m(i,j,:) =   temp_m(i,j,:) +   temp(i,j,:)**2 * sw(:)
              saln_m(i,j,:) =   saln_m(i,j,:) +   saln(i,j,:)**2 * sw(:)
              th3d_m(i,j,:) =   th3d_m(i,j,:) +   th3d(i,j,:)**2 * sw(:)
                ke_m(i,j,:) =     ke_m(i,j,:) +     ke(i,j,:)**2 * sw(:)
            tracer_m(i,j,:) = tracer_m(i,j,:) + tracer(i,j,:)**2 * sw(:)
          endif !ip
        enddo
      enddo
*
*     write(6,*) 'mean_addsq -    dp_m = ',   dp_m(54, 1,1),
*    &                                        dp(  54, 1,1)**2
*


      end subroutine mean_addsq


      subroutine mean_copy
      implicit none
c
c --- copy archive to mean archive
c
         nmean = nstep
c
           u_m =      u
           v_m =      v
          ke_m =     ke
        temp_m =   temp
        saln_m =   saln
        th3d_m =   th3d
          dp_m =     dp
          dw_m =     dw
      tracer_m = tracer
c
       ubaro_m =  ubaro
       vbaro_m =  vbaro
       pbaro_m =  pbaro
      kebaro_m = kebaro
       montg_m =  montg
       srfht_m =  srfht
        dpbl_m =   dpbl
      dpmixl_m = dpmixl
        tmix_m =   tmix
        smix_m =   smix
       thmix_m =  thmix
        umix_m =   umix
        vmix_m =   vmix
       kemix_m =  kemix
      surflx_m = surflx
      salflx_m = salflx
      covice_m = covice
      thkice_m = thkice
      temice_m = temice
*
*     write(6,*) 'mean_copy  -    dp_m = ',   dp_m(54, 1,1),
*    &                                        dp(  54, 1,1)
*


      end subroutine mean_copy


      subroutine mean_depths
      implicit none
c
c --- calculate depthu and depthv
c
      integer i,im,j,jm
c
      depths(:,:) = 9806.0 * depths(:,:)  ! convert to pressure units
c
      do j= 1,jj
        do i= 1,ii
          if     (i.ne.1) then
            im = i-1
          else
            im = ii
          endif
          if     (min(ip(i,j),ip(im,j)).eq.1) then
            depthu(i,j) = min(depths(i,j),depths(im,j))
          elseif (ip(i ,j).eq.1) then
            depthu(i,j) = depths(i ,j)
          elseif (ip(im,j).eq.1) then
            depthu(i,j) = depths(im,j)
          else
            depthu(i,j) = 0.0
          endif
c
          if     (j.ne.1) then
            jm = j-1
          else
            jm = jj
          endif
          if     (min(ip(i,j),ip(i,jm)).eq.1) then
            depthv(i,j) = min(depths(i,j),depths(i,jm))
          elseif (ip(i,j) .eq.1) then
            depthv(i,j) = depths(i,j)
          elseif (ip(i,jm).eq.1) then
            depthv(i,j) = depths(i,jm)
          else
            depthv(i,j) = 0.0
          endif
        enddo
      enddo
      end subroutine mean_depths


      subroutine mean_end
      implicit none
c
c --- reduce sum of archives to their mean.
c
      real       spval
      parameter (spval=2.0**100)
c
      integer i,im,j,jm,k
      real    s,swk,sw(kk)
c
      s = 1.0/nmean
c
      do j= 1,jj
        do i= 1,ii
          if     (ip(i,j).eq.1) then
            p(i,j,1) = 0.0
            do k= 1,kk
              p(i,j,k+1) = p(i,j,k) + dw_m(i,j,k)*s
            enddo
          else
            p(i,j,:) = 0.0
          endif
        enddo
      enddo
c
      do j= 1,jj
        do i= 1,ii
          if     (iu(i,j).eq.1) then
            if     (i.ne.1) then
              im = i-1
            else
              im = ii
            endif
            do k= 1,kk
!              swk = min(depthu(i,j), 0.5*(p(i,j,k+1)+p(im,j,k+1))) -
!     &              min(depthu(i,j), 0.5*(p(i,j,k  )+p(im,j,k  )))
              swk = max(0. ,0.5*(p(i,j,k+1)+p(im,j,k+1)) -
     &              0.5*(p(i,j,k  )+p(im,j,k  )))
              if     (swk.ge.0.000001) then
                swk = s/swk
                u_m(i,j,k) = u_m(i,j,k) * swk
              else  ! project into zero thickness layers
                u_m(i,j,k) = u_m(i,j,k-1)
              endif
            enddo
            ubaro_m(i,j)   = ubaro_m(i,j) * s
             umix_m(i,j)   =  umix_m(i,j) * s
          else
                u_m(i,j,:) = spval
            ubaro_m(i,j)   = spval
             umix_m(i,j)   = spval
          endif !iu
c
          if     (iv(i,j).eq.1) then
            if     (j.ne.1) then
              jm = j-1
            else
              jm = jj
            endif
            do k= 1,kk
!              swk = min(depthv(i,j), 0.5*(p(i,j,k+1)+p(i,jm,k+1))) -
!     &              min(depthv(i,j), 0.5*(p(i,j,k  )+p(i,jm,k  )))
              swk = max(0., 0.5*(p(i,j,k+1)+p(i,jm,k+1)) -
     &              0.5*(p(i,j,k  )+p(i,jm,k  )))
              if     (swk.ge.0.000001) then
                swk = s/swk
                v_m(i,j,k) = v_m(i,j,k) * swk
              else  ! project into zero thickness layers
                v_m(i,j,k) = v_m(i,j,k-1)
              endif
            enddo
            vbaro_m(i,j)   = vbaro_m(i,j) * s
             vmix_m(i,j)   =  vmix_m(i,j) * s
          else
                v_m(i,j,:) = spval
            vbaro_m(i,j)   = spval
             vmix_m(i,j)   = spval
          endif
c
          if     (ip(i,j).eq.1) then
             pbaro_m(i,j)   =  pbaro_m(i,j)   * s
            kebaro_m(i,j)   = kebaro_m(i,j)   * s
             montg_m(i,j)   =  montg_m(i,j)   * s
             srfht_m(i,j)   =  srfht_m(i,j)   * s
              dpbl_m(i,j)   =   dpbl_m(i,j)   * s
            dpmixl_m(i,j)   = dpmixl_m(i,j)   * s
              tmix_m(i,j)   =   tmix_m(i,j)   * s
              smix_m(i,j)   =   smix_m(i,j)   * s
             thmix_m(i,j)   =  thmix_m(i,j)   * s
             kemix_m(i,j)   =  kemix_m(i,j)   * s
            surflx_m(i,j)   = surflx_m(i,j)   * s
            salflx_m(i,j)   = salflx_m(i,j)   * s
            covice_m(i,j)   = covice_m(i,j)   * s
            thkice_m(i,j)   = thkice_m(i,j)   * s
            temice_m(i,j)   = temice_m(i,j)   * s
c
            do k= 1,kk
              dw_m(i,j,k) = dw_m(i,j,k) * s
              dp_m(i,j,k) = dp_m(i,j,k) * s
              if     (dw_m(i,j,k).ge.0.000001) then
                            swk = s/dw_m(i,j,k)
                  temp_m(i,j,k) =   temp_m(i,j,k) * swk
                  saln_m(i,j,k) =   saln_m(i,j,k) * swk
                  th3d_m(i,j,k) =   th3d_m(i,j,k) * swk
                    ke_m(i,j,k) =     ke_m(i,j,k) * swk
                tracer_m(i,j,k) = tracer_m(i,j,k) * swk
              else  ! project into zero thickness layers
                  temp_m(i,j,k) =   temp_m(i,j,k-1)
                  saln_m(i,j,k) =   saln_m(i,j,k-1)
                  th3d_m(i,j,k) =   th3d_m(i,j,k-1)
                    ke_m(i,j,k) =     ke_m(i,j,k-1)
                tracer_m(i,j,k) = tracer_m(i,j,k-1)
              endif
            enddo
          else
             pbaro_m(i,j)   = spval
            kebaro_m(i,j)   = spval
             montg_m(i,j)   = spval
             srfht_m(i,j)   = spval
              dpbl_m(i,j)   = spval
            dpmixl_m(i,j)   = spval
              tmix_m(i,j)   = spval
              smix_m(i,j)   = spval
             thmix_m(i,j)   = spval
             kemix_m(i,j)   = spval
            surflx_m(i,j)   = spval
            salflx_m(i,j)   = spval
            covice_m(i,j)   = spval
            thkice_m(i,j)   = spval
            temice_m(i,j)   = spval
c
                dw_m(i,j,:) = spval
                dp_m(i,j,:) = spval
              temp_m(i,j,:) = spval
              saln_m(i,j,:) = spval
              th3d_m(i,j,:) = spval
                ke_m(i,j,:) = spval
            tracer_m(i,j,:) = spval
          endif
        enddo
      enddo
*
*     write(6,*) 'mean_end   -    dp_m = ',   dp_m(54, 1,1)
*


      end subroutine mean_end


      subroutine mean_std
      implicit none
c
c --- form the std.dev = sqrt(mnsq-mean**2)
c
      real, parameter :: zero = 0.0
c
      integer i,j,k
c
      real std,x
      std(x) = sqrt(max(zero,x))
c
      do j= 1,jj
        do i= 1,ii
          do k= 1,kk
            if     (iu(i,j).eq.1) then
                   u_m(i,j,k) = std(     u(i,j,k) -      u_m(i,j,k)**2)
            endif
            if     (iv(i,j).eq.1) then
                   v_m(i,j,k) = std(     v(i,j,k) -      v_m(i,j,k)**2)
            endif
            if     (ip(i,j).eq.1) then
                temp_m(i,j,k) = std(  temp(i,j,k) -   temp_m(i,j,k)**2)
                saln_m(i,j,k) = std(  saln(i,j,k) -   saln_m(i,j,k)**2)
                th3d_m(i,j,k) = std(  th3d(i,j,k) -   th3d_m(i,j,k)**2)
                  dw_m(i,j,k) =                         dp_m(i,j,k)
                  dp_m(i,j,k) = std(    dp(i,j,k) -     dp_m(i,j,k)**2)
                  ke_m(i,j,k) = std(    ke(i,j,k) -     ke_m(i,j,k)**2)
              tracer_m(i,j,k) = std(tracer(i,j,k) - tracer_m(i,j,k)**2)
            endif
          enddo
c
          if     (iu(i,j).eq.1) then
             ubaro_m(i,j) = std( ubaro(i,j) -  ubaro_m(i,j)**2)
              umix_m(i,j) = std(  umix(i,j) -   umix_m(i,j)**2)
          endif
          if     (iv(i,j).eq.1) then
             vbaro_m(i,j) = std( vbaro(i,j) -  vbaro_m(i,j)**2)
              vmix_m(i,j) = std(  vmix(i,j) -   vmix_m(i,j)**2)
          endif
          if     (ip(i,j).eq.1) then
             pbaro_m(i,j) = std( pbaro(i,j) -  pbaro_m(i,j)**2)
            kebaro_m(i,j) = std(kebaro(i,j) - kebaro_m(i,j)**2)
             montg_m(i,j) = std( montg(i,j) -  montg_m(i,j)**2)
             srfht_m(i,j) = std( srfht(i,j) -  srfht_m(i,j)**2)
              dpbl_m(i,j) = std(  dpbl(i,j) -   dpbl_m(i,j)**2)
            dpmixl_m(i,j) = std(dpmixl(i,j) - dpmixl_m(i,j)**2)
              tmix_m(i,j) = std(  tmix(i,j) -   tmix_m(i,j)**2)
              smix_m(i,j) = std(  smix(i,j) -   smix_m(i,j)**2)
             thmix_m(i,j) = std( thmix(i,j) -  thmix_m(i,j)**2)
             kemix_m(i,j) = std( kemix(i,j) -  kemix_m(i,j)**2)
            surflx_m(i,j) = std(surflx(i,j) - surflx_m(i,j)**2)
            salflx_m(i,j) = std(salflx(i,j) - salflx_m(i,j)**2)
            covice_m(i,j) = std(covice(i,j) - covice_m(i,j)**2)
            thkice_m(i,j) = std(thkice(i,j) - thkice_m(i,j)**2)
            temice_m(i,j) = std(temice(i,j) - temice_m(i,j)**2)
          endif
        enddo
      enddo
*
*     write(6,*) 'mean_std   -    dp_m = ',   dp_m(54, 1,1),
*    &                                        dw_m(54, 1,1),
*    &                                        dp(  54, 1,1)
*


      end subroutine mean_std


      subroutine mean_velocity
      implicit none
c
c --- update velocity to include depth averaged component, and
c --- calculate kinetic energy.
c --- only called for standard archive fields.
c
      integer i,j,ip1
c
      do j= 1,jj
        do i= 1,ii
          if     (iu(i,j).eq.1) then
               u(i,j,:) =    u(i,j,:) + ubaro(i,j)
            umix(i,j)   = umix(i,j)   + ubaro(i,j)
          endif
          if     (iv(i,j).eq.1) then
               v(i,j,:) =    v(i,j,:) + vbaro(i,j)
            vmix(i,j)   = vmix(i,j)   + vbaro(i,j)
          endif
        enddo
      enddo
c
      do j= 1,jj
        do i= 1,ii
          if     (i.ne.ii) then
            ip1 = i+1
          else
            ip1 = 1
          endif
          if     (ip(i,j).eq.1) then
c           kinetic energy / mass (m**2/s**2)
                ke(i,j,:) = 0.5*
     &                      ((0.5*(    u(i,j,:) +     u(ip1,j,:)))**2 +
     &                       (0.5*(    v(i,j,:) +     v(i,j+1,:)))**2  )
             kemix(i,j)   = 0.5*
     &                      ((0.5*( umix(i,j)   +  umix(ip1,j)  ))**2 +
     &                       (0.5*( vmix(i,j)   +  vmix(i,j+1)  ))**2  )
            kebaro(i,j)   = 0.5*
     &                      ((0.5*(ubaro(i,j)   + ubaro(ip1,j)  ))**2 +
     &                       (0.5*(vbaro(i,j)   + vbaro(i,j+1)  ))**2  )
          endif
        enddo
      enddo
*
*     write(6,*) 'mean_velocity -   ke = ',     ke(54, 1,1)
*


      end subroutine mean_velocity


      end module mod_mean
