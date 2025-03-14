!==========================================================================================!
!==========================================================================================!
!     This is the main loader of ecosystem parameters.  Since some compilers do not under- !
! stand the assignment in the modules when the variable is not a constant (parameter),     !
! this is the safest way to guarantee it will read something (not to mention that makes    !
! compilation much faster when you want to test the sensitivity of one number).            !
!------------------------------------------------------------------------------------------!
subroutine load_ed_ecosystem_params()

   use ed_max_dims , only : n_pft               ! ! intent(in)
   use pft_coms    , only : include_these_pft   & ! intent(in)
                          , agri_stock          & ! intent(in)
                          , plantation_stock    & ! intent(in)
                          , pft_name16          & ! intent(out)
                          , is_tropical         & ! intent(out)
                          , is_grass            & ! intent(out)
                          , include_pft         & ! intent(out)
                          , include_pft_ag      & ! intent(out)
                          , include_pft_fp      & ! intent(out)
                          , C2B                 & ! intent(out)
                          , frost_mort          ! ! intent(out)
   use disturb_coms, only : ianth_disturb       ! ! intent(in)

   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   integer :: p
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Main table of Plant functional types.  If you add some PFT, please make sure     !
   ! that you assign values for all PFT-dependent variables.  Below is a summary table of  !
   ! the main characteristics of the currently available PFTs.                             !
   !---------------------------------------------------------------------------------------!
   !  PFT | Name                                       | Grass   | Tropical | agriculture? !
   !------+--------------------------------------------+---------+----------+--------------!
   !    1 | C4 grass                                   |     yes |      yes |          yes !
   !    2 | Early tropical                             |      no |      yes |           no !
   !    3 | Mid tropical                               |      no |      yes |           no !
   !    4 | Late tropical                              |      no |      yes |           no !
   !    5 | Temperate C3 grass                         |     yes |       no |          yes !
   !    6 | Northern pines                             |      no |       no |           no !
   !    7 | Southern pines                             |      no |       no |           no !
   !    8 | Late conifers                              |      no |       no |           no !
   !    9 | Early temperate deciduous                  |      no |       no |           no !
   !   10 | Mid temperate deciduous                    |      no |       no |           no !
   !   11 | Late temperate deciduous                   |      no |       no |           no !
   !   12 | C3 pasture                                 |     yes |       no |          yes !
   !   13 | C3 crop (e.g.,wheat, rice, soybean)        |     yes |       no |          yes !
   !   14 | C4 pasture                                 |     yes |      yes |          yes !
   !   15 | C4 crop (e.g.,corn/maize)                  |     yes |      yes |          yes !
   !   16 | Tropical C3 grass                          |     yes |      yes |          yes !
   !   17 | Araucaria (similar to 7, tropical allom.)  |      no |      yes |           no !
   !   18 | Shrub                                      |      no |       no |           no !       ! CHANGED
   !------+--------------------------------------------+---------+----------+--------------!

   !----- Name the PFTs (no spaces, please). ----------------------------------------------!
   pft_name16( 1) = 'C4_grass        '
   pft_name16( 2) = 'Early_tropical  '
   pft_name16( 3) = 'Mid_tropical    '
   pft_name16( 4) = 'Late_tropical   '
   pft_name16( 5) = 'C3_grass        '
   pft_name16( 6) = 'North_pine      '
   pft_name16( 7) = 'South_pine      '
   pft_name16( 8) = 'Late_conifer    '
   pft_name16( 9) = 'Early_hardwood  '
   pft_name16(10) = 'Mid_hardwood    '
   pft_name16(11) = 'Late_hardwood   '
   pft_name16(12) = 'C3_pasture      '
   pft_name16(13) = 'C3_crop         '
   pft_name16(14) = 'C4_pasture      '
   pft_name16(15) = 'C4_crop         '
   pft_name16(16) = 'Subtrop_C3_grass'
   pft_name16(17) = 'Araucaria       '
   pft_name16(18) = 'Shrub           '                                                            ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------! 
   !    This flag should be used to define whether the plant is tropical/subtropical or    !
   ! not.                                                                                  !
   !---------------------------------------------------------------------------------------! 
   is_tropical(1:4)   = .true.
   is_tropical(5:11)  = .false.
   is_tropical(12:13) = .false.
   is_tropical(14:15) = .true.
   is_tropical(16)    = .true.
   !---------------------------------------------------------------------------------------!
   !     This uses tropical allometry for DBH->Bleaf and DBH->Bdead, but otherwise it uses !
   ! the temperate properties.                                                             !
   !---------------------------------------------------------------------------------------!
   is_tropical(17)    = .true.
   is_tropical(18)    = .false.                                                                   ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------! 
   !    This flag should be used to define whether the plant is tree or grass              !
   !---------------------------------------------------------------------------------------! 
   is_grass(1)     = .true.
   is_grass(2:4)   = .false.
   is_grass(5)     = .true.
   is_grass(6:11)  = .false.
   is_grass(12:15) = .true.
   is_grass(16)    = .true.
   is_grass(17)    = .false.
   is_grass(18)    = .false.                                                                      ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Include_pft: flag specifying to whether you want to include a plant functional     !
   !                 type (T) or whether you want it excluded (F) from the simulation.     !
   !---------------------------------------------------------------------------------------!
   include_pft    = .false.
   do p=1,n_pft
      if (include_these_pft(p) >  0 .and. include_these_pft(p) <= n_pft) then
         include_pft(include_these_pft(p)) = .true.
      end if
   end do
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Only the PFTs listed in agri_stock are allowed in agriculture patches.  For the   !
   ! time being this means a single PFT, but it could change in the future.                !
   !---------------------------------------------------------------------------------------!
   include_pft_ag             = .false.
   include_pft_ag(agri_stock) = is_grass(agri_stock) .and. include_pft(agri_stock)
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Only the PFTs listed in plantation_stock are allowed in agriculture patches.  For !
   ! the time being this means a single PFT, but it could change in the future.            !
   !---------------------------------------------------------------------------------------!
   include_pft_fp                   = .false.
   include_pft_fp(plantation_stock) = ( .not. is_grass(plantation_stock) ) .and.           &
                                      include_pft(plantation_stock)
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Warn the user in case the PFT choice for agriculture or forest plantation was    !
   ! inconsistent.                                                                         !
   !---------------------------------------------------------------------------------------!
   if (count(include_pft_ag) == 0 .and. ianth_disturb == 1) then
      call warning ('PFT defined in agri_stock is not included in include_these_pft,'//    &
                    ' your croplands will be barren and not very profitable...'            &
                   ,'load_ecosystem_params','ed_params.f90')
   end if
   if (count(include_pft_fp) == 0 .and. ianth_disturb == 1) then
      call warning ('PFT defined in plantation_stock is not listed in include_these_pft,'//&
                    ' your forest plantation will be barren and not very profitable ...'   &
                   ,'load_ecosystem_params','ed_params.f90')
   end if
   !---------------------------------------------------------------------------------------!




   !----- Load several parameters ---------------------------------------------------------!
   call init_decomp_params()
   call init_ff_coms()
   call init_disturb_params()
   call init_physiology_params()
   call init_met_params()
   call init_lapse_params()
   call init_hydro_coms()
   call init_soil_coms()
   call init_phen_coms()
   call init_ed_misc_coms()
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Assign many PFT-dependent parameters.  Here the order may matter, so think twice  !
   ! before changing the order.                                                            !
   !---------------------------------------------------------------------------------------!
   !----- Photosynthesis and leaf respiration. --------------------------------------------!
   call init_pft_photo_params()
   !----- Root and heterotrophic respiration. ---------------------------------------------!
   call init_pft_resp_params()
   !----- Allometry and some plant traits. ------------------------------------------------!
   call init_pft_alloc_params()
   !----- Mortality. ----------------------------------------------------------------------!
   call init_pft_mort_params()
   !----- Nitrogen. -----------------------------------------------------------------------!
   call init_pft_nitro_params()
   !----- Miscellaneous leaf properties. --------------------------------------------------!
   call init_pft_leaf_params()
   !----- Reproduction. -------------------------------------------------------------------!
   call init_pft_repro_params()
   !----- Miscellaneous parameters that depend on the previous ones. ----------------------!
   call init_pft_derived_params()
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Assign canopy properties.  This must be done after defining the PFT stuff.        !
   ! Again, check the routines and think twice before changing the order.                  !
   !---------------------------------------------------------------------------------------!
   !----- Canopy turbulence and aerodynamic resistance. -----------------------------------!
   call init_can_air_params()
   !----- Canopy radiation properties. ----------------------------------------------------!
   call init_can_rad_params()
   !----- Canopy splitting into height layers. --------------------------------------------!
   call init_can_lyr_params()
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !     This should be always the last one, since it depends on variables assigned in the !
   ! previous init_????_params.                                                            !
   !---------------------------------------------------------------------------------------!
   call init_rk4_params()
   !---------------------------------------------------------------------------------------!

   return
end subroutine load_ed_ecosystem_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This subroutine assigns values for some variables that are in ed_misc_coms, which    !
! wouldn't fit in any of the other categories.                                             !
!------------------------------------------------------------------------------------------!
subroutine init_ed_misc_coms
   use ed_max_dims  , only : n_pft                & ! intent(in)
                           , n_dbh                & ! intent(in)
                           , n_age                ! ! intent(in)
   use consts_coms  , only : erad                 & ! intent(in)
                           , pio180               ! ! intent(in)
   use ed_misc_coms , only : burnin               & ! intent(out)
                           , outputMonth          & ! intent(out)
                           , restart_target_year  & ! intent(out)
                           , use_target_year      & ! intent(out)
                           , maxage               & ! intent(out)
                           , dagei                & ! intent(out)
                           , maxdbh               & ! intent(out)
                           , ddbhi                & ! intent(out)
                           , vary_elev            & ! intent(out)
                           , vary_hyd             & ! intent(out)
                           , vary_rad             & ! intent(out)
                           , max_thsums_dist      & ! intent(out)
                           , max_poihist_dist     & ! intent(out)
                           , max_poi99_dist       & ! intent(out)
                           , suppress_h5_warnings ! ! intent(out)
   implicit none


   !----- Flags that allow components of subgrid heterogeneity to be turned on/off --------!
   vary_elev = 1
   vary_rad  = 1
   vary_hyd  = 1
   !---------------------------------------------------------------------------------------!


   !----- Number of years to ignore demography when starting a run. -----------------------!
   burnin = 0
   !---------------------------------------------------------------------------------------!


   !----- Month to output the yearly files. -----------------------------------------------!
   outputMonth = 6
   !---------------------------------------------------------------------------------------!


   !----- Year to read when parsing pss/css with multiple years. --------------------------!
   restart_target_year = 2000
   !---------------------------------------------------------------------------------------!


   !----- Flag specifying whether to search for a target year in pss/css. -----------------!
   use_target_year = 0    
   !---------------------------------------------------------------------------------------!



   !----- Maximum age [yr] to split into classes. -----------------------------------------!
   maxage = 200.
   !---------------------------------------------------------------------------------------!



   !----- Maximum DBH [cm] to be split into classes. --------------------------------------!
   maxdbh = 200.                                                                                      !COME BACK TO. I changed from 100 to 200 so that shrub dbh classes are more realistic but this will affect all pfts so if want to include trees, keep on eye on this parameter
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     The inverse of bin classes will depend on max??? and n_???, leaving one class for !
   ! when the number exceeds the maximum.                                                  !
   !---------------------------------------------------------------------------------------!
   dagei = real(n_age-1) / maxage
   ddbhi = real(n_dbh-1) / maxdbh
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Maximum distance to the current polygon that we still consider the file grid point !
   ! to be representative of the polygon.  The value below is 1.25 degree at the Equator.  !
   !---------------------------------------------------------------------------------------!
   max_thsums_dist    = 1.25 * erad * pio180
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Alternative method for mixing 1 grid and POI's.  Only use the grid if their is   !
   ! NOT an POI  within a user specified resolution.  Remember, this assumes there is only !
   ! 1 gridded file, and it is the first file when ied_init_mode is set to 99  (Developer  !
   ! use only).                                                                            !
   !---------------------------------------------------------------------------------------!
   max_poi99_dist     = 5.0 * erad * pio180
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      This variable is used for the history start initialisation.  This sets the       !
   ! maximum acceptable distance between the expected polygon and the polygon found in the !
   ! history file.  Units: m.                                                              !
   !---------------------------------------------------------------------------------------!
   max_poihist_dist   = 250.
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      If you don't want to read a million warnings about certain initialization        !
   ! variables not being available in the history input file, set this to .true. .  It's   !
   ! better for new users to see what is missing though.                                   !
   !---------------------------------------------------------------------------------------!
   suppress_h5_warnings = .true.
   !---------------------------------------------------------------------------------------!


   return
end subroutine init_ed_misc_coms
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This subroutine defines the minimum and maximum acceptable values in the meteoro-    !
! logical forcing.                                                                         !
!------------------------------------------------------------------------------------------!
subroutine init_met_params()
   use ed_misc_coms   , only : dtlsm           ! ! intent(in)
   use met_driver_coms, only : rshort_min      & ! intent(out)
                             , rshort_max      & ! intent(out)
                             , rlong_min       & ! intent(out)
                             , rlong_max       & ! intent(out)
                             , dt_radinterp    & ! intent(out)
                             , atm_tmp_min     & ! intent(out)
                             , atm_tmp_max     & ! intent(out)
                             , atm_shv_min     & ! intent(out)
                             , atm_shv_max     & ! intent(out)
                             , atm_rhv_min     & ! intent(out)
                             , atm_rhv_max     & ! intent(out)
                             , atm_co2_min     & ! intent(out)
                             , atm_co2_max     & ! intent(out)
                             , prss_min        & ! intent(out)
                             , prss_max        & ! intent(out)
                             , pcpg_min        & ! intent(out)
                             , pcpg_max        & ! intent(out)
                             , vels_min        & ! intent(out)
                             , vels_max        & ! intent(out)
                             , geoht_min       & ! intent(out)
                             , geoht_max       & ! intent(out)
                             , print_radinterp & ! intent(out)
                             , vbdsf_file      & ! intent(out)
                             , vddsf_file      & ! intent(out)
                             , nbdsf_file      & ! intent(out)
                             , nddsf_file      ! ! intent(out)


   !----- Minimum and maximum acceptable shortwave radiation [W/m�]. ----------------------!
   rshort_min  = 0.
   rshort_max  = 1500.
   !----- Minimum and maximum acceptable longwave radiation [W/m�]. -----------------------!
   rlong_min   = 40.
   rlong_max   = 600.
   !----- Minimum and maximum acceptable air temperature    [   K]. -----------------------!
   atm_tmp_min = 184.     ! Lowest temperature ever measured, in Vostok Basin, Antarctica
   atm_tmp_max = 331.     ! Highest temperature ever measured, in El Azizia, Libya
   !----- Minimum and maximum acceptable air specific humidity [kg_H2O/kg_air]. -----------!
   atm_shv_min = 1.e-6    ! That corresponds to a relative humidity of 0.1% at 1000hPa
   atm_shv_max = 3.2e-2   ! That corresponds to a dew point of 32�C at 1000hPa.
   !----- Minimum and maximum acceptable CO2 mixing ratio [�mol/mol]. ---------------------!
   atm_co2_min = 100.     ! 
   atm_co2_max = 1100.    ! 
   !----- Minimum and maximum acceptable pressure [Pa]. -----------------------------------!
   prss_min =  45000. ! It may crash if you run a simulation in Mt. Everest.
   prss_max = 110000. ! It may crash if you run a simulation under water.
   !----- Minimum and maximum acceptable precipitation rates [kg/m�/s]. -------------------!
   pcpg_min     = 0.0     ! No negative precipitation is allowed
   pcpg_max     = 0.1111  ! This is a precipitation rate of 400mm/hr.
   !----- Minimum and maximum acceptable wind speed [m/s]. --------------------------------!
   vels_min     =  0.0    ! No negative wind is acceptable.
   vels_max     = 85.0    ! Maximum sustained winds recorded during Typhoon Tip (1970).
   !----- Minimum and maximum reference heights [m]. --------------------------------------!
   geoht_min    =   1.0   ! This should be above-canopy measurement, but 1.0 is okay for
                          !     grasslands...
   geoht_max    = 350.0   ! This should be not that much above the canopy, but tall towers
                          !     do exist...
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !     Minimum and maximum acceptable relative humidity (fraction).  This is not going   !
   ! cause the simulation to crash, instead it will just impose these numbers to the       !
   ! meteorological forcing.                                                               !
   !---------------------------------------------------------------------------------------!
   atm_rhv_min = 5.e-3 ! 0.5%
   atm_rhv_max = 1.0   ! 100.0%.  Although canopy air space can experience super-
                       !    saturation, we don't allow the air above to be super-saturated.
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Time step used to perform the daytime average of the secant of the zenith angle.  !
   !---------------------------------------------------------------------------------------!
   dt_radinterp = dtlsm    ! Value in seconds.
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !   These variables control the detailed interpolation output (for debugging only).     !
   !---------------------------------------------------------------------------------------!
   print_radinterp = .false.
   vbdsf_file      = 'visible_beam.txt'
   vddsf_file      = 'visible_diff.txt'
   nbdsf_file      = 'near_infrared_beam.txt'
   nddsf_file      = 'near_infrared_diff.txt'
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_met_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This subroutine defines defaults for lapse rates.                                    !
!------------------------------------------------------------------------------------------!
subroutine init_lapse_params()

   use met_driver_coms, only : lapse             & ! intent(out)
                             , atm_tmp_intercept & ! intent(out)
                             , atm_tmp_slope     & ! intent(out)
                             , prec_intercept    & ! intent(out)
                             , prec_slope        & ! intent(out)
                             , humid_scenario    ! ! intent(out)

   lapse%geoht        = 0.0
   lapse%atm_ustar    = 0.0
   lapse%vels         = 0.0
   lapse%atm_tmp      = 0.0
   lapse%atm_theta    = 0.0
   lapse%atm_theiv    = 0.0
   lapse%atm_vpdef    = 0.0
   lapse%atm_shv      = 0.0
   lapse%prss         = 0.0
   lapse%pcpg         = 0.0
   lapse%atm_co2      = 0.0
   lapse%rlong        = 0.0
   lapse%nir_beam     = 0.0
   lapse%nir_diffuse  = 0.0
   lapse%par_beam     = 0.0
   lapse%par_diffuse  = 0.0
   lapse%pptnorm      = 0.0

   atm_tmp_intercept = 0.0
   atm_tmp_slope     = 1.0
   prec_intercept    = 0.0
   prec_slope        = 1.0
   humid_scenario    = 0

   return
end subroutine init_lapse_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine will assign some radiation related parameters.                        !
!------------------------------------------------------------------------------------------!
subroutine init_can_rad_params()

   use canopy_radiation_coms , only : ltrans_vis                  & ! intent(in)
                                    , ltrans_nir                  & ! intent(in)
                                    , lreflect_vis                & ! intent(in)
                                    , lreflect_nir                & ! intent(in)
                                    , orient_tree                 & ! intent(in)
                                    , orient_grass                & ! intent(in)
                                    , clump_tree                  & ! intent(in)
                                    , clump_grass                 & ! intent(in)
                                    , leaf_reflect_nir            & ! intent(in)
                                    , leaf_trans_nir              & ! intent(in)
                                    , leaf_scatter_nir            & ! intent(out)
                                    , leaf_reflect_vis            & ! intent(in)
                                    , leaf_trans_vis              & ! intent(in)
                                    , leaf_scatter_vis            & ! intent(out)
                                    , leaf_backscatter_vis        & ! intent(in)
                                    , leaf_backscatter_nir        & ! intent(in)
                                    , leaf_backscatter_tir        & ! intent(out)
                                    , leaf_emiss_tir              & ! intent(out)
                                    , clumping_factor             & ! intent(out)
                                    , orient_factor               & ! intent(out)
                                    , phi1                        & ! intent(out)
                                    , phi2                        & ! intent(out)
                                    , mu_bar                      & ! intent(out)
                                    , wood_reflect_nir            & ! intent(in)
                                    , wood_trans_nir              & ! intent(in)
                                    , wood_scatter_nir            & ! intent(out)
                                    , wood_reflect_vis            & ! intent(in)
                                    , wood_trans_vis              & ! intent(in)
                                    , wood_scatter_vis            & ! intent(out)
                                    , wood_reflect_vis            & ! intent(in)
                                    , wood_trans_vis              & ! intent(in)
                                    , wood_scatter_tir            & ! intent(out)
                                    , wood_backscatter_vis        & ! intent(in)
                                    , wood_backscatter_nir        & ! intent(in)
                                    , wood_backscatter_tir        & ! intent(out)
                                    , wood_emiss_tir              & ! intent(out)
                                    , fvis_beam_def               & ! intent(out)
                                    , fvis_diff_def               & ! intent(out)
                                    , fnir_beam_def               & ! intent(out)
                                    , fnir_diff_def               & ! intent(out)
                                    , snow_albedo_vis             & ! intent(out)
                                    , snow_albedo_nir             & ! intent(out)
                                    , snow_emiss_tir              & ! intent(out)
                                    , rshort_twilight_min         & ! intent(out)
                                    , cosz_min                    & ! intent(out)
                                    , cosz_min8                   ! ! intent(out)
   use consts_coms           , only : pio180                      & ! intent(out)
                                    , twothirds8                  ! ! intent(out)
   use ed_max_dims           , only : n_pft                       ! ! intent(out)
   implicit none
   !----- Arguments. ----------------------------------------------------------------------!
   integer :: ipft
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !      The following parameters are used to split the shortwave radiation into visible  !
   ! and near-infrared radiation.                                                          !
   !---------------------------------------------------------------------------------------!
   fvis_beam_def = 0.43
   fnir_beam_def = 1.0 - fvis_beam_def
   fvis_diff_def = 0.52
   fnir_diff_def = 1.0 - fvis_diff_def
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Clumping factor.  This factor indicates the degree of clumpiness of leaves.       !a
   !  0 -- black hole                                                                      !
   !  1 -- homogeneous, no clumping.                                                       !
   !---------------------------------------------------------------------------------------!
   clumping_factor(1)     = dble(clump_grass)
   clumping_factor(2:4)   = dble(clump_tree )
   clumping_factor(5)     = 8.400d-1
   clumping_factor(6:8)   = 7.350d-1
   clumping_factor(9:11)  = 8.400d-1
   clumping_factor(12:13) = 8.400d-1
   clumping_factor(14:15) = dble(clump_grass)
   clumping_factor(16)    = dble(clump_grass)
   clumping_factor(17)    = 7.350d-1
   clumping_factor(18)    = 8.400d-1                                                                 ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Orientation factor.  The numbers come from CLM, and the original value from      !
   ! ED-2.1 used to 0.  This works in the following way:                                   !
   !  0 -- leaves are randomly oriented                                                    !
   !  1 -- all leaves are perfectly horizontal                                             !
   ! -1 -- all leaves are perfectly vertical.                                              !
   !---------------------------------------------------------------------------------------!
   orient_factor(    1) = dble(orient_grass)
   orient_factor(  2:4) = dble(orient_tree)
   orient_factor(    5) = 0.0d0 ! -3.0d-1 ! CLM value for C3 grass
   orient_factor(  6:8) = 0.0d0 !  1.0d-2 ! CLM value for temperate evergreen needleef tree
   orient_factor( 9:11) = 0.0d0 !  2.5d-1 ! CLM value for temperate deciduous broadleaf tree
   orient_factor(12:13) = 0.0d0 ! -3.0d-1 ! CLM value for C3 grass
   orient_factor(14:15) = dble(orient_grass) ! -3.0d-1 ! CLM value for C4 grass
   orient_factor(   16) = dble(orient_grass)
   orient_factor(   17) = 1.0d-2 ! CLM value for temperate evergreen needleef
   orient_factor(   18) = 0.0d0                                                                      ! CHANGED
   !---------------------------------------------------------------------------------------!






   !---------------------------------------------------------------------------------------!
   !      Emissivity on Thermal infra-red (TIR).                                           !
   !---------------------------------------------------------------------------------------!
   !----- Leaves. -------------------------------------------------------------------------!
   leaf_emiss_tir(1)     = 9.60d-1
   leaf_emiss_tir(2:4)   = 9.50d-1
   leaf_emiss_tir(5)     = 9.60d-1
   leaf_emiss_tir(6:8)   = 9.70d-1
   leaf_emiss_tir(9:11)  = 9.50d-1
   leaf_emiss_tir(12:15) = 9.60d-1
   leaf_emiss_tir(16)    = 9.60d-1
   leaf_emiss_tir(17)    = 9.70d-1
   leaf_emiss_tir(18)    = 9.70d-1                                                                 ! CHANGED
   !----- Branches. -----------------------------------------------------------------------!
   wood_emiss_tir(1)     = 9.60d-1
   wood_emiss_tir(2:4)   = 9.00d-1
   wood_emiss_tir(5)     = 9.60d-1
   wood_emiss_tir(6:8)   = 9.00d-1
   wood_emiss_tir(9:11)  = 9.00d-1
   wood_emiss_tir(12:15) = 9.60d-1
   wood_emiss_tir(16)    = 9.60d-1
   wood_emiss_tir(17)    = 9.00d-1
   wood_emiss_tir(18)    = 9.00d-1                                                                 ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Leaf reflectance.                                                                !
   !      Values for temperate PFTs were left as they were.  Tropical and sub-tropical     !
   ! PFTs use the parameters from CLM.  I checked the values against some published and    !
   ! they seem similar at a first glance, at least closer than the original values, which  !
   ! looked like the visible ignoring the green band.                                      !
   !                                                                                       !
   ! Tropical / Subtropical values for visible came from:                                  !
   ! - Poorter, L., S. F. Oberbauer, D. B. Clark, 1995: Leaf optical properties along a    !
   !      vertical gradient in a tropical rainforest in Costa Rica. American J. of Botany, !
   !      82, 1257-1263.                                                                   !
   ! Tropical values for NIR were estimated from:                                          !
   ! - Roberts, D. A., B. W. Nelson, J. B. Adams, F. Palmer, 1998: Spectral changes with   !
   !      leaf aging in Amazon caatinga. Trees, 12, 315-325.                               !
   !---------------------------------------------------------------------------------------!
   !----- Visible (PAR). ------------------------------------------------------------------!
   leaf_reflect_vis(1)     = dble(lreflect_vis)
   leaf_reflect_vis(2)     = dble(lreflect_vis)
   leaf_reflect_vis(3)     = dble(lreflect_vis)
   leaf_reflect_vis(4)     = dble(lreflect_vis)
   leaf_reflect_vis(5)     = 1.10d-1 ! 6.2d-2
   leaf_reflect_vis(6:11)  = 1.10d-1 ! 1.1d-1
   leaf_reflect_vis(12:13) = 1.10d-1 ! 1.1d-1
   leaf_reflect_vis(14:15) = dble(lreflect_vis)
   leaf_reflect_vis(16)    = dble(lreflect_vis)
   leaf_reflect_vis(17)    = 9.00d-2 ! 9.0d-2
   leaf_reflect_vis(18)    = 3.00d-1                                                               ! CHANGED
   !----- Near infrared. ------------------------------------------------------------------!
   leaf_reflect_nir(1)     = dble(lreflect_nir)
   leaf_reflect_nir(2:4)   = dble(lreflect_nir)
   leaf_reflect_nir(5)     = 5.77d-1
   leaf_reflect_nir( 6:11) = 5.77d-1
   leaf_reflect_nir(12:13) = 5.77d-1
   leaf_reflect_nir(14:15) = dble(lreflect_nir)
   leaf_reflect_nir(16)    = dble(lreflect_nir)
   leaf_reflect_nir(17)    = 5.77d-1
   leaf_reflect_nir(18)    = 5.77d-1                                                               ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Wood reflectance, using values based on:                                         !
   !                                                                                       !
   ! Asner, G., 1998: Biophysical and biochemical sources of variability in canopy         !
   !     reflectance. Remote Sensing of Environment, 64, 234-253.                          !
   !                                                                                       !
   ! Commented values are from CLM, but they were quite high.                              !
   !---------------------------------------------------------------------------------------!
   !----- Visible (PAR). ------------------------------------------------------------------!
   wood_reflect_vis(1)     = 1.60d-1  ! 3.10d-1
   wood_reflect_vis(2:4)   = 1.10d-1  ! 1.60d-1
   wood_reflect_vis(5)     = 1.60d-1  ! 3.10d-1
   wood_reflect_vis(6:11)  = 1.10d-1  ! 1.60d-1
   wood_reflect_vis(12:13) = 1.60d-1  ! 3.10d-1
   wood_reflect_vis(14:15) = 1.10d-1  ! 3.10d-1
   wood_reflect_vis(16)    = 1.60d-1  ! 3.10d-1
   wood_reflect_vis(17)    = 1.10d-1  ! 1.60d-1
   wood_reflect_vis(18)    = 1.10d-1                                                               ! CHANGED
   !----- Near infrared. ------------------------------------------------------------------!
   wood_reflect_nir(1)     = 2.50d-1  ! 5.30d-1
   wood_reflect_nir(2:4)   = 2.50d-1  ! 3.90d-1
   wood_reflect_nir(5)     = 2.50d-1  ! 5.30d-1
   wood_reflect_nir( 6:11) = 2.50d-1  ! 3.90d-1
   wood_reflect_nir(12:13) = 2.50d-1  ! 5.30d-1
   wood_reflect_nir(14:15) = 2.50d-1  ! 5.30d-1
   wood_reflect_nir(16)    = 2.50d-1  ! 5.30d-1
   wood_reflect_nir(17)    = 2.50d-1  ! 3.90d-1
   wood_reflect_nir(18)    = 2.50d-1                                                               ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Leaf transmittance.                                                              !
   !      Values for temperate PFTs were left as they were.  Tropical and sub-tropical     !
   ! PFTs use the parameters from CLM.  I checked the values against some published and    !
   ! they seem similar at a first glance, at least closer than the original values, which  !
   ! looked like the visible ignoring the green band.                                      !
   !                                                                                       !
   ! Tropical / Subtropical values for visible came from:                                  !
   ! - Poorter, L., S. F. Oberbauer, D. B. Clark, 1995: Leaf optical properties along a    !
   !      vertical gradient in a tropical rainforest in Costa Rica. American J. of Botany, !
   !      82, 1257-1263.                                                                   !
   ! Tropical values for NIR were estimated from:                                          !
   ! - Roberts, D. A., B. W. Nelson, J. B. Adams, F. Palmer, 1998: Spectral changes with   !
   !      leaf aging in Amazon caatinga. Trees, 12, 315-325.                               !
   !---------------------------------------------------------------------------------------!
   !----- Visible (PAR). ------------------------------------------------------------------!
   leaf_trans_vis(    1) = dble(ltrans_vis)
   leaf_trans_vis(    2) = dble(ltrans_vis)
   leaf_trans_vis(    3) = dble(ltrans_vis)
   leaf_trans_vis(    4) = dble(ltrans_vis)
   leaf_trans_vis(    5) = 1.60d-1  ! 0.160
   leaf_trans_vis( 6:11) = 1.60d-1  ! 0.160
   leaf_trans_vis(12:13) = 1.60d-1  ! 0.160
   leaf_trans_vis(14:15) = dble(ltrans_vis)
   leaf_trans_vis(   16) = dble(ltrans_vis)
   leaf_trans_vis(   17) = 5.00d-2  ! 0.160
   leaf_trans_vis(   18) = 1.60d-1                                                                 ! CHANGED
   !----- Near infrared. ------------------------------------------------------------------!
   leaf_trans_nir(    1) = dble(ltrans_nir)
   leaf_trans_nir(  2:4) = dble(ltrans_nir)
   leaf_trans_nir(    5) = 2.48d-1
   leaf_trans_nir( 6:11) = 2.48d-1
   leaf_trans_nir(12:13) = 2.48d-1
   leaf_trans_nir(14:15) = dble(ltrans_nir)
   leaf_trans_nir(   16) = dble(ltrans_nir)
   leaf_trans_nir(   17) = 2.48d-1
   leaf_trans_nir(   18) = 2.48d-1                                                                 ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Wood transmittance, using the parameters from CLM.                               !
   !---------------------------------------------------------------------------------------!
   !----- Visible (PAR). ------------------------------------------------------------------!
   wood_trans_vis(    1) = 2.80d-2
   wood_trans_vis(  2:4) = 1.00d-3
   wood_trans_vis(    5) = 2.80d-2
   wood_trans_vis( 6:11) = 1.00d-3
   wood_trans_vis(12:13) = 2.20d-1
   wood_trans_vis(14:15) = 2.20d-1
   wood_trans_vis(   16) = 2.80d-2
   wood_trans_vis(   17) = 1.00d-3
   wood_trans_vis(   18) = 1.00d-3                                                                 ! CHANGED
   !----- Near infrared. ------------------------------------------------------------------!
   wood_trans_nir(    1) = 2.48d-1
   wood_trans_nir(  2:4) = 1.00d-3
   wood_trans_nir(    5) = 2.48d-1
   wood_trans_nir( 6:11) = 1.00d-3
   wood_trans_nir(12:13) = 2.48d-1
   wood_trans_nir(14:15) = 2.48d-1
   wood_trans_nir(   16) = 2.48d-1
   wood_trans_nir(   17) = 1.00d-3
   wood_trans_nir(   18) = 1.00d-3                                                                 ! CHANGED
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Thermal scattering coefficients.  Contrary to ED-2.1, these values are based on   !
   ! the description by by Sellers (1985) and the CLM technical manual, which includes the !
   ! leaf orientation factor in the backscattering.  This DOES NOT reduce to ED-2.1 case   !
   ! when the leaf orientation is random.                                                  !
   !---------------------------------------------------------------------------------------!
   do ipft = 1, n_pft
      !------------------------------------------------------------------------------------!
      !      Thermal infra-red (TIR): Here we use the same expression from CLM manual,     !
      ! further assuming that the transmittance is zero like Zhao and Qualls (2006) did,   !
      ! the backscattering coefficient becomes a function of the leaf orientation only.    !
      ! We don't have different orientation factor for wood (we could have), so we assume  !
      ! them to be the same as leaves.                                                     !
      !------------------------------------------------------------------------------------!
      leaf_backscatter_tir(ipft) = 5.d-1 + 1.25d-1 * (1 + orient_factor(ipft)) ** 2
      wood_backscatter_tir(ipft) = 5.d-1 + 1.25d-1 * (1 + orient_factor(ipft)) ** 2
      !------------------------------------------------------------------------------------!
   end do
   !---------------------------------------------------------------------------------------!





   !---------------------------------------------------------------------------------------!
   !     Optical properties for snow.  Values are a first guess, and a more thorough snow  !
   ! model that takes snow age and snow melt into account (like in CLM-4 or ECHAM-5) are   !
   ! very welcome.                                                                         !
   !                                                                                       !
   !  References for current snow values:                                                  !
   !  Roesch, A., et al., 2002: Comparison of spectral surface albedos and their           !
   !      impact on the general circulation model simulated surface climate.  J.           !
   !      Geophys. Res.-Atmosph., 107(D14), 4221, 10.1029/2001JD000809.                    !
   !      Average between minimum and maximum snow albedo on land, af = 0. and af=1.       !
   !                                                                                       !
   !  Oleson, K.W., et al., 2010: Technical description of version 4.0 of the              !
   !      Community Land Model (CLM). NCAR Technical Note NCAR/TN-478+STR.                 !
   !                                                                                       !
   !---------------------------------------------------------------------------------------!
   snow_albedo_vis = 0.518
   snow_albedo_nir = 0.435
   snow_emiss_tir  = 0.970
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     These variables are the thresholds for things that should be computed during the  !
   ! day time hours only.                                                                  !
   !---------------------------------------------------------------------------------------!
   rshort_twilight_min = 0.5
   cosz_min            = cos(89.*pio180) !cos(89.5*pio180)
   cosz_min8           = dble(cosz_min)
   !---------------------------------------------------------------------------------------!


   return
end subroutine init_can_rad_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine will assign some canopy air related parameters.                       !
!------------------------------------------------------------------------------------------!
subroutine init_can_air_params()
   use consts_coms    , only : onethird              & ! intent(in)
                             , twothirds             & ! intent(in)
                             , onesixth              & ! intent(in)
                             , vonk                  ! ! intent(in)
   use pft_coms       , only : hgt_min               & ! intent(in)
                             , hgt_max               ! ! intent(in)
   use canopy_air_coms, only : psim                  & ! function
                             , psih                  & ! function
                             , ugbmin                & ! intent(in)
                             , ubmin                 & ! intent(in)
                             , ustmin                & ! intent(in)
                             , gamm                  & ! intent(in)
                             , gamh                  & ! intent(in)
                             , tprandtl              & ! intent(in)
                             , vh2vr                 & ! intent(out)
                             , vh2dh                 & ! intent(out)
                             , ribmax                & ! intent(out)
                             , leaf_drywhc           & ! intent(out)
                             , leaf_maxwhc           & ! intent(out)
                             , gbhmos_min            & ! intent(out)
                             , gbhmos_min8           & ! intent(out)
                             , veg_height_min        & ! intent(out)
                             , veg_height_min8       & ! intent(out)
                             , minimum_canopy_depth  & ! intent(out)
                             , minimum_canopy_depth8 & ! intent(out)
                             , exar                  & ! intent(out)
                             , covr                  & ! intent(out)
                             , exar8                 & ! intent(out)
                             , ez                    & ! intent(out)
                             , ustmin8               & ! intent(out)
                             , ugbmin8               & ! intent(out)
                             , ubmin8                & ! intent(out)
                             , ez8                   & ! intent(out)
                             , vh2vr8                & ! intent(out)
                             , vh2dh8                & ! intent(out)
                             , cdrag0                & ! intent(out)
                             , cdrag1                & ! intent(out)
                             , cdrag2                & ! intent(out)
                             , cdrag3                & ! intent(out)
                             , pm0                   & ! intent(out)
                             , c1_m97                & ! intent(out)
                             , c2_m97                & ! intent(out)
                             , c3_m97                & ! intent(out)
                             , kvwake                & ! intent(out)
                             , alpha_m97             & ! intent(out)
                             , alpha_mw99            & ! intent(out)
                             , gamma_mw99            & ! intent(out)
                             , nu_mw99               & ! intent(out)
                             , infunc                & ! intent(out)
                             , cs_dense0             & ! intent(out)
                             , gamma_clm4            & ! intent(out)
                             , cdrag08               & ! intent(out)
                             , cdrag18               & ! intent(out)
                             , cdrag28               & ! intent(out)
                             , cdrag38               & ! intent(out)
                             , pm08                  & ! intent(out)
                             , c1_m978               & ! intent(out)
                             , c2_m978               & ! intent(out)
                             , c3_m978               & ! intent(out)
                             , kvwake8               & ! intent(out)
                             , alpha_m97_8           & ! intent(out)
                             , alpha_mw99_8          & ! intent(out)
                             , gamma_mw99_8          & ! intent(out)
                             , nu_mw99_8             & ! intent(out)
                             , infunc_8              & ! intent(out)
                             , cs_dense08            & ! intent(out)
                             , gamma_clm48           & ! intent(out)
                             , bl79                  & ! intent(out)
                             , csm                   & ! intent(out)
                             , csh                   & ! intent(out)
                             , dl79                  & ! intent(out)
                             , beta_s                & ! intent(out)
                             , abh91                 & ! intent(out)
                             , bbh91                 & ! intent(out)
                             , cbh91                 & ! intent(out)
                             , dbh91                 & ! intent(out)
                             , ebh91                 & ! intent(out)
                             , fbh91                 & ! intent(out)
                             , cod                   & ! intent(out)
                             , bcod                  & ! intent(out)
                             , fm1                   & ! intent(out)
                             , ate                   & ! intent(out)
                             , atetf                 & ! intent(out)
                             , z0moz0h               & ! intent(out)
                             , z0hoz0m               & ! intent(out)
                             , beta_vs               & ! intent(out)
                             , chim                  & ! intent(out)
                             , chih                  & ! intent(out)
                             , zetac_um              & ! intent(out)
                             , zetac_uh              & ! intent(out)
                             , zetac_sm              & ! intent(out)
                             , zetac_sh              & ! intent(out)
                             , zetac_umi             & ! intent(out)
                             , zetac_uhi             & ! intent(out)
                             , zetac_smi             & ! intent(out)
                             , zetac_shi             & ! intent(out)
                             , zetac_umi16           & ! intent(out)
                             , zetac_uhi13           & ! intent(out)
                             , psimc_um              & ! intent(out)
                             , psihc_uh              & ! intent(out)
                             , bl798                 & ! intent(out)
                             , csm8                  & ! intent(out)
                             , csh8                  & ! intent(out)
                             , dl798                 & ! intent(out)
                             , beta_s8               & ! intent(out)
                             , gamm8                 & ! intent(out)
                             , gamh8                 & ! intent(out)
                             , ribmax8               & ! intent(out)
                             , tprandtl8             & ! intent(out)
                             , abh918                & ! intent(out)
                             , bbh918                & ! intent(out)
                             , cbh918                & ! intent(out)
                             , dbh918                & ! intent(out)
                             , ebh918                & ! intent(out)
                             , fbh918                & ! intent(out)
                             , cod8                  & ! intent(out)
                             , bcod8                 & ! intent(out)
                             , fm18                  & ! intent(out)
                             , ate8                  & ! intent(out)
                             , atetf8                & ! intent(out)
                             , z0moz0h8              & ! intent(out)
                             , z0hoz0m8              & ! intent(out)
                             , beta_vs8              & ! intent(out)
                             , chim8                 & ! intent(out)
                             , chih8                 & ! intent(out)
                             , zetac_um8             & ! intent(out)
                             , zetac_uh8             & ! intent(out)
                             , zetac_sm8             & ! intent(out)
                             , zetac_sh8             & ! intent(out)
                             , zetac_umi8            & ! intent(out)
                             , zetac_uhi8            & ! intent(out)
                             , zetac_smi8            & ! intent(out)
                             , zetac_shi8            & ! intent(out)
                             , zetac_umi168          & ! intent(out)
                             , zetac_uhi138          & ! intent(out)
                             , psimc_um8             & ! intent(out)
                             , psihc_uh8             & ! intent(out)
                             , aflat_turb            & ! intent(out)
                             , aflat_lami            & ! intent(out)
                             , bflat_turb            & ! intent(out)
                             , bflat_lami            & ! intent(out)
                             , nflat_turb            & ! intent(out)
                             , nflat_lami            & ! intent(out)
                             , mflat_turb            & ! intent(out)
                             , mflat_lami            & ! intent(out)
                             , ocyli_turb            & ! intent(out)
                             , ocyli_lami            & ! intent(out)
                             , acyli_turb            & ! intent(out)
                             , acyli_lami            & ! intent(out)
                             , bcyli_turb            & ! intent(out)
                             , bcyli_lami            & ! intent(out)
                             , ncyli_turb            & ! intent(out)
                             , ncyli_lami            & ! intent(out)
                             , mcyli_turb            & ! intent(out)
                             , mcyli_lami            & ! intent(out)
                             , aflat_turb8           & ! intent(out)
                             , aflat_lami8           & ! intent(out)
                             , bflat_turb8           & ! intent(out)
                             , bflat_lami8           & ! intent(out)
                             , nflat_turb8           & ! intent(out)
                             , nflat_lami8           & ! intent(out)
                             , mflat_turb8           & ! intent(out)
                             , mflat_lami8           & ! intent(out)
                             , ocyli_turb8           & ! intent(out)
                             , ocyli_lami8           & ! intent(out)
                             , acyli_turb8           & ! intent(out)
                             , acyli_lami8           & ! intent(out)
                             , bcyli_turb8           & ! intent(out)
                             , bcyli_lami8           & ! intent(out)
                             , ncyli_turb8           & ! intent(out)
                             , ncyli_lami8           & ! intent(out)
                             , mcyli_turb8           & ! intent(out)
                             , mcyli_lami8           & ! intent(out)
                             , ggsoil0               & ! intent(out)
                             , kksoil                & ! intent(out)
                             , ggsoil08              & ! intent(out)
                             , kksoil8               ! ! intent(out)
   implicit none
   !----- External functions. -------------------------------------------------------------!
   real   , external :: cbrt
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Minimum leaf water content to be considered.  Values smaller than this will be     !
   ! flushed to zero.  This value is in kg/[m2 tree], so it will be scaled by (LAI+WAI)    !
   ! where needed be.                                                                      !
   !---------------------------------------------------------------------------------------!
   leaf_drywhc = 5.e-4 * leaf_maxwhc
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !      Variables to define the vegetation aerodynamic conductance.  They are currently  !
   ! not PFT dependent.                                                                    !
   !---------------------------------------------------------------------------------------!
   gbhmos_min  = 1.e-9
   gbhmos_min8 = dble(gbhmos_min)
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   ! veg_height_min       - This is the minimum vegetation height allowed [m].  Vegetation !
   !                        height is used to calculate drag coefficients and patch        !
   !                        roughness.                                                     !
   ! minimum_canopy_depth - This is the minimum canopy depth allowed [m].  Canopy depth    !
   !                        is used to calculate the heat and moisture storage capacity in !
   !                        the canopy air space.                                          !
   !---------------------------------------------------------------------------------------!
   veg_height_min        = minval(hgt_min)
   minimum_canopy_depth  = 5.0  ! alternative: minval(hgt_min) 

   !----- This is the dimensionless exponential wind atenuation factor. -------------------!
   exar  = 2.5

   !----- This is the scaling factor of tree area index (not sure if it is used...) -------!
   covr = 2.16


   !---------------------------------------------------------------------------------------!
   !      Parameters for surface layer models.                                             !
   !---------------------------------------------------------------------------------------!
   !----- Vegetation roughness:vegetation height ratio. -----------------------------------!
   vh2vr    = 0.13
   !----- Displacement height:vegetation height ratio. ------------------------------------!
   vh2dh    = 0.63
   !---------------------------------------------------------------------------------------!




   !----- Louis (1979) model. -------------------------------------------------------------!
   bl79        = 5.0    ! b prime parameter
   csm         = 7.5    ! C* for momentum (eqn. 20, not co2 char. scale)
   csh         = 5.0    ! C* for heat (eqn.20, not co2 char. scale)
   dl79        = 5.0    ! ???
   !----- Oncley and Dudhia (1995) model. -------------------------------------------------!
   beta_s       = 5.0          ! Beta 
   !----- Beljaars and Holtslag (1991) model. ---------------------------------------------!
   abh91       = -1.00         ! -a from equation  (28) and (32)
   bbh91       = -twothirds    ! -b from equation  (28) and (32)
   cbh91       =  5.0          !  c from equations (28) and (32)
   dbh91       =  0.35         !  d from equations (28) and (32)
   ebh91       = -twothirds    ! - factor multiplying a*zeta in equation (32)
   fbh91       =  1.50         ! exponent in equation (32)
   cod         = cbh91/dbh91   ! c/d
   bcod        = bbh91 * cod   ! b*c/d
   fm1         = fbh91 - 1.0   ! f-1
   ate         = abh91 * ebh91 ! a * e
   atetf       = ate   * fbh91 ! a * e * f
   z0moz0h     = 1.0           ! z0(M)/z0(h)
   z0hoz0m     = 1. / z0moz0h  ! z0(M)/z0(h)
   !----- Similar to CLM (2004), but with different phi_m for very unstable case. ---------!
   zetac_um    = -1.5
   zetac_uh    = -0.5
   zetac_sm    =  1.0
   zetac_sh    =  zetac_sm
   !----- Define chim and chih so the functions are continuous. ---------------------------!
   chim        = (-zetac_um) ** onesixth / sqrt(sqrt(1.0 - gamm * zetac_um))
   chih        = cbrt(-zetac_uh) / sqrt(1.0 - gamh * zetac_uh)
   beta_vs     = 1.0 - (1.0 - beta_s) * zetac_sm
   !----- Define derived values to speed up the code a little. ----------------------------!
   zetac_umi   = 1.0 / zetac_um
   zetac_uhi   = 1.0 / zetac_uh
   zetac_smi   = 1.0 / zetac_sm
   zetac_shi   = 1.0 / zetac_sh
   zetac_umi16 = 1.0 / (- zetac_um) ** onesixth
   zetac_uhi13 = 1.0 / cbrt(-zetac_uh)

   !---------------------------------------------------------------------------------------!
   !     Initialise these values with dummies, it will be updated after we define the      !
   ! functions.                                                                            !
   !---------------------------------------------------------------------------------------!
   psimc_um  = 0.
   psimc_um  = psim(zetac_um,.false.)
   psihc_uh  = 0.
   psihc_uh  = psih(zetac_uh,.false.)
   !---------------------------------------------------------------------------------------!


   
   !----- Legacy variable, we can probably remove it. -------------------------------------!
   ez  = 0.172
   !---------------------------------------------------------------------------------------!







   !---------------------------------------------------------------------------------------!
   !      Parameters for the aerodynamic resistance between the leaf (flat surface) and    !
   ! wood (kind of cylinder surface), and the canopy air space.  These are the A, B, n,    !
   ! and m parameters that define the Nusselt number for forced and free convection, at    !
   ! equations 10.7 and 10.9.  The parameters are found at the appendix A, table A.5(a)    !
   ! and A.5(b).                                                                           !
   !                                                                                       !
   ! M08 - Monteith, J. L., M. H. Unsworth, 2008. Principles of Environmental Physics,     !
   !       3rd. edition, Academic Press, Amsterdam, 418pp.  (Mostly Chapter 10).           !
   !                                                                                       !
   ! The coefficient B for flat plates under turbulent flow was changed to 0.19 so the     !
   !     transition from laminar to turbulent regime will happen at Gr ~ 100,000, the      !
   !     number suggested by M08.                                                          !
   !---------------------------------------------------------------------------------------!
   aflat_lami = 0.600    ! A (forced convection), laminar   flow
   nflat_lami = 0.500    ! n (forced convection), laminar   flow
   aflat_turb = 0.032    ! A (forced convection), turbulent flow
   nflat_turb = 0.800    ! n (forced convection), turbulent flow
   bflat_lami = 0.500    ! B (free   convection), laminar   flow
   mflat_lami = 0.250    ! m (free   convection), laminar   flow
   bflat_turb = 0.190    ! B (free   convection), turbulent flow
   mflat_turb = onethird ! m (free   convection), turbulent flow
   ocyli_lami = 0.320    ! intercept (forced convection), laminar   flow
   acyli_lami = 0.510    ! A (forced convection), laminar   flow
   ncyli_lami = 0.520    ! n (forced convection), laminar   flow
   ocyli_turb = 0.000    ! intercept (forced convection), turbulent flow
   acyli_turb = 0.240    ! A (forced convection), turbulent flow
   ncyli_turb = 0.600    ! n (forced convection), turbulent flow
   bcyli_lami = 0.480    ! B (free   convection), laminar   flow
   mcyli_lami = 0.250    ! m (free   convection), laminar   flow
   bcyli_turb = 0.090    ! B (free   convection), turbulent flow
   mcyli_turb = onethird ! m (free   convection), turbulent flow
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Define the variables that are going to be used by Massman (1997) and Massman and  !
   ! Weil (1999).  Full reference:                                                         !
   !                                                                                       !
   ! Massman, W. J., 1997: An analytical one-dimensional model of momentum transfer by     !
   !    vegetation of arbitrary structure.  Boundary-Layer Meteorol., 83, 407-421.         !
   !                                                                                       !
   ! Massman, W. J., and J. C. Weil, 1999: An analytical one-dimension second-order clos-  !
   !    ure model turbulence statistics and the Lagrangian time scale within and above     !
   !    plant canopies of arbitrary structure.  Boundary-Layer Meteorol., 91, 81-107.      !
   !                                                                                       !
   ! Wohlfahrt, G., and A. Cernusca, 2002: Momentum transfer by a mountain meadow canopy:  !
   !    a simulation analysis based on Massman's (1997) model.  Boundary-Layer Meteorol.,  !
   !    103, 391-407.
   !---------------------------------------------------------------------------------------!
   !----- Fluid drag coefficient for turbulent flow in leaves. ----------------------------!
   cdrag0    = 0.2
   !----- Values from re-fit of the data used by WC02. ------------------------------------!
   cdrag1    = 0.086
   cdrag2    = 1.192
   cdrag3    = 0.480
   !----- Sheltering factor of fluid drag on canopies. ------------------------------------!
   pm0       = 1.0
   !----- Surface drag parameters (Massman 1997). -----------------------------------------!
   c1_m97    = 0.320 
   c2_m97    = 0.264
   c3_m97    = 15.1
   !----- Eddy diffusivity due to Von Karman Wakes in gravity flows. ----------------------!
   kvwake    = 0.001
   !---------------------------------------------------------------------------------------!
   !     Alpha factors to produce the profile of sheltering factor and within canopy drag, !
   ! as suggested by Massman (1997) and Massman and Weil (1999).                           !
   !---------------------------------------------------------------------------------------!
   alpha_m97  = 5.00
   alpha_mw99 = 0.03
   !---------------------------------------------------------------------------------------!
   !      Parameter to represent the roughness sublayer effect.  According to Massman,     !
   ! assuming this to be zero means that the sublayer effects will be ignored.  Otherwise  !
   ! Raupach (1994) tried values up to 0.316.                                              !
   !---------------------------------------------------------------------------------------!
   infunc    = 0.193
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Parameters for CLM, at equation 5.103 of CLM-4 techical note.                     !
   !     Oleson, K. W., et al.; Technical description of version 4.0 of the community land !
   !        model (CLM) NCAR Technical Note NCAR/TN-478+STR, Boulder, CO, April 2010.      !
   !---------------------------------------------------------------------------------------!
   cs_dense0  = 0.004
   gamma_clm4 = 0.5
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !  Gamma and nu are the parameters that close equation 10 in Massman and Weil (1999).   !
   !  VERY IMPORTANT: If you mess with gamma, you must recompute nu!                       !
   !---------------------------------------------------------------------------------------!
   gamma_mw99 = (/2.4, 1.9, 1.25/)
   nu_mw99    = (/0.3024,3.4414,36.1476/)
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !   Soil conductance terms, from:                                                       !
   !                                                                                       !
   ! Passerat de Silans, A., 1986: Transferts de masse et de chaleur dans un sol stratifi� !
   !     soumis � une excitation amtosph�rique naturelle. Comparaison: Mod�les-exp�rience. !
   !     Thesis, Institut National Polytechnique de Grenoble. (P86)                        !
   !                                                                                       !
   ! retrieved from:                                                                       !
   ! Mahfouf, J. F., J. Noilhan, 1991: Comparative study of various formulations of        !
   !     evaporation from bare soil using in situ data. J. Appl. Meteorol., 30, 1354-1365. !
   !     (MN91)                                                                            !
   !                                                                                       !
   !     Please notice that the values are inverted because we compute conductance, not    !
   ! resistance.                                                                           !
   !---------------------------------------------------------------------------------------!
   ggsoil0 = 1. / 38113.
   kksoil  = 13.515
   !---------------------------------------------------------------------------------------!



   !----- Set the double precision variables. ---------------------------------------------!
   veg_height_min8       = dble(veg_height_min      )
   minimum_canopy_depth8 = dble(minimum_canopy_depth)
   exar8                 = dble(exar                )
   ubmin8                = dble(ubmin               )
   ugbmin8               = dble(ugbmin              )
   ustmin8               = dble(ustmin              )
   ez8                   = dble(ez                  )
   vh2vr8                = dble(vh2vr               )
   vh2dh8                = dble(vh2dh               )
   bl798                 = dble(bl79                )
   csm8                  = dble(csm                 )
   csh8                  = dble(csh                 )
   dl798                 = dble(dl79                )
   beta_s8               = dble(beta_s              )
   gamm8                 = dble(gamm                )
   gamh8                 = dble(gamh                )
   ribmax8               = dble(ribmax              )
   tprandtl8             = dble(tprandtl            )
   abh918                = dble(abh91               )
   bbh918                = dble(bbh91               )
   cbh918                = dble(cbh91               )
   dbh918                = dble(dbh91               )
   ebh918                = dble(ebh91               )
   fbh918                = dble(fbh91               )
   cod8                  = dble(cod                 )
   bcod8                 = dble(bcod                )
   fm18                  = dble(fm1                 )
   ate8                  = dble(ate                 )
   atetf8                = dble(atetf               )
   z0moz0h8              = dble(z0moz0h             )
   z0hoz0m8              = dble(z0hoz0m             )
   aflat_lami8           = dble(aflat_lami          )
   nflat_lami8           = dble(nflat_lami          )
   aflat_turb8           = dble(aflat_turb          )
   nflat_turb8           = dble(nflat_turb          )
   bflat_lami8           = dble(bflat_lami          )
   mflat_lami8           = dble(mflat_lami          )
   bflat_turb8           = dble(bflat_turb          )
   mflat_turb8           = dble(mflat_turb          )
   ocyli_lami8           = dble(ocyli_lami          )
   acyli_lami8           = dble(acyli_lami          )
   ncyli_lami8           = dble(ncyli_lami          )
   ocyli_turb8           = dble(ocyli_turb          )
   acyli_turb8           = dble(acyli_turb          )
   ncyli_turb8           = dble(ncyli_turb          )
   bcyli_lami8           = dble(bcyli_lami          )
   mcyli_lami8           = dble(mcyli_lami          )
   bcyli_turb8           = dble(bcyli_turb          )
   mcyli_turb8           = dble(mcyli_turb          )
   cdrag08               = dble(cdrag0              )
   cdrag18               = dble(cdrag1              )
   cdrag28               = dble(cdrag2              )
   cdrag38               = dble(cdrag3              )
   pm08                  = dble(pm0                 )
   c1_m978               = dble(c1_m97              )
   c2_m978               = dble(c2_m97              )
   c3_m978               = dble(c3_m97              )
   kvwake8               = dble(kvwake              )
   alpha_m97_8           = dble(alpha_m97           )
   alpha_mw99_8          = dble(alpha_mw99          )
   gamma_mw99_8          = dble(gamma_mw99          )
   nu_mw99_8             = dble(nu_mw99             )
   infunc_8              = dble(infunc              )
   cs_dense08            = dble(cs_dense0           )
   ggsoil08              = dble(ggsoil0             )
   kksoil8               = dble(kksoil              )
   zetac_um8             = dble(zetac_um            )
   zetac_uh8             = dble(zetac_uh            )
   zetac_sm8             = dble(zetac_sm            )
   zetac_sh8             = dble(zetac_sh            )
   chim8                 = dble(chim                )
   chih8                 = dble(chih                )
   beta_vs8              = dble(beta_vs             )
   zetac_umi8            = dble(zetac_umi           )
   zetac_uhi8            = dble(zetac_uhi           )
   zetac_smi8            = dble(zetac_smi           )
   zetac_shi8            = dble(zetac_shi           )
   zetac_umi168          = dble(zetac_umi16         )
   zetac_uhi138          = dble(zetac_uhi13         )
   psimc_um8             = dble(psimc_um            )
   psimc_um8             = dble(psimc_um            )
   psihc_uh8             = dble(psihc_uh            )
   psihc_uh8             = dble(psihc_uh            )
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_can_air_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This sub-routine initialises some of the canopy layer variables.  These are used     !
! by sub-routines that need to calculate the canopy properties by layers rather than by    !
! cohorts (or when both must be considered).                                               !
!------------------------------------------------------------------------------------------!
subroutine init_can_lyr_params()
   use canopy_layer_coms, only : tai_lyr_max                 & ! intent(out)
                               , ncanlyr                     & ! intent(out)
                               , ncanlyrp1                   & ! intent(out)
                               , ncanlyrt2                   & ! intent(out)
                               , zztop0                      & ! intent(out)
                               , zztop08                     & ! intent(out)
                               , zztop0i                     & ! intent(out)
                               , zztop0i8                    & ! intent(out)
                               , ehgt                        & ! intent(out)
                               , ehgt8                       & ! intent(out)
                               , ehgti                       & ! intent(out)
                               , ehgti8                      & ! intent(out)
                               , dzcan                       & ! intent(out)
                               , dzcan8                      & ! intent(out)
                               , zztop                       & ! intent(out)
                               , zzmid                       & ! intent(out)
                               , zzbot                       & ! intent(out)
                               , zztop8                      & ! intent(out)
                               , zzmid8                      & ! intent(out)
                               , zzbot8                      & ! intent(out)
                               , alloc_canopy_layer          ! ! subroutine
   use pft_coms         , only : hgt_min                     & ! intent(in)
                               , hgt_max                     ! ! intent(in)
   use consts_coms      , only : onethird                    & ! intent(in)
                               , onethird8                   ! ! intent(in)
   implicit none
   !----- Local variables. ----------------------------------------------------------------!
   integer    :: ilyr
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !      Set the maximum tai that each layer is allowed to have.                          !
   !---------------------------------------------------------------------------------------!
   tai_lyr_max = 1.0
   !---------------------------------------------------------------------------------------!



   !----- Find the layer thickness and the number of layers needed. -----------------------!
   ncanlyr   = 100
   ncanlyrp1 = ncanlyr + 1
   ncanlyrt2 = ncanlyr * 2
   zztop0    = onethird  * minval(hgt_min)
   zztop08   = onethird8 * dble(minval(hgt_min))
   zztop0i   = 1.   / zztop0
   zztop0i8  = 1.d0 / zztop08
   ehgt      = log(maxval(hgt_max)/zztop0)        / log(real(ncanlyr))
   ehgt8     = log(dble(maxval(hgt_max))/zztop08) / log(dble(ncanlyr))
   ehgti     = 1./ ehgt
   ehgti8    = 1.d0 / ehgt8
   !---------------------------------------------------------------------------------------!



   !----- Allocate the variables. ---------------------------------------------------------!
   call alloc_canopy_layer()
   !---------------------------------------------------------------------------------------!



   !----- Define the layer heights. -------------------------------------------------------!
   do ilyr =1,ncanlyr
      zztop (ilyr) = zztop0 * real(ilyr  ) ** ehgt
      zzbot (ilyr) = zztop0 * real(ilyr-1) ** ehgt
      dzcan (ilyr) = zztop(ilyr) - zzbot(ilyr)
      zzmid (ilyr) = 0.5 * (zzbot(ilyr) + zztop(ilyr))
      zztop8(ilyr) = zztop0  * dble(ilyr  ) ** ehgt8
      zzbot8(ilyr) = zztop08 * dble(ilyr-1) ** ehgt8
      dzcan8(ilyr) = zztop8(ilyr) - zzbot8(ilyr)
      zzmid8(ilyr) = 5.d-1 * (zzbot8(ilyr) + zztop8(ilyr))
   end do
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_can_lyr_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_pft_photo_params()

   use ed_max_dims    , only : n_pft                   ! ! intent(in)
   use ed_misc_coms   , only : ibigleaf                & ! intent(in)
                             , iallom                  ! ! intent(in)
   use pft_coms       , only : D0                      & ! intent(out)
                             , Vm_low_temp             & ! intent(out)
                             , Vm_high_temp            & ! intent(out)
                             , Vm_decay_e              & ! intent(out)
                             , Vm_decay_a              & ! intent(out)
                             , Vm_decay_b              & ! intent(out)
                             , Vm0                     & ! intent(out)
                             , Vm_hor                  & ! intent(out)
                             , Vm_q10                  & ! intent(out)
                             , Rd_low_temp             & ! intent(out)
                             , Rd_high_temp            & ! intent(out)
                             , Rd_decay_e              & ! intent(out)
                             , Rd0                     & ! intent(out)
                             , Rd_hor                  & ! intent(out)
                             , Rd_q10                  & ! intent(out)
                             , stomatal_slope          & ! intent(out)
                             , leaf_width              & ! intent(out)
                             , cuticular_cond          & ! intent(out)
                             , quantum_efficiency      & ! intent(out)
                             , photosyn_pathway        & ! intent(out)
                             , dark_respiration_factor & ! intent(out)
                             , water_conductance       ! ! intent(out)
   use consts_coms    , only : t00                     & ! intent(in)
                             , twothirds               & ! intent(in)
                             , umol_2_mol              & ! intent(in)
                             , yr_sec                  ! ! intent(in)
   use physiology_coms , only: iphysiol                & ! intent(in)
                             , vmfact_c3               & ! intent(in)
                             , vmfact_c4               & ! intent(in)
                             , mphoto_trc3             & ! intent(in)
                             , mphoto_tec3             & ! intent(in)
                             , mphoto_c4               & ! intent(in)
                             , bphoto_blc3             & ! intent(in)
                             , bphoto_nlc3             & ! intent(in)
                             , bphoto_c4               & ! intent(in)
                             , gamma_c3                & ! intent(in)
                             , gamma_c4                & ! intent(in)
                             , d0_grass                & ! intent(in)
                             , d0_tree                 & ! intent(in)
                             , alpha_c3                & ! intent(in)
                             , alpha_c4                & ! intent(in)
                             , kw_grass                & ! intent(in)
                             , kw_tree                 & ! intent(in)
                             , lwidth_grass            & ! intent(in)
                             , lwidth_bltree           & ! intent(in)
                             , lwidth_nltree           & ! intent(in)
                             , q10_c3                  & ! intent(in)
                             , q10_c4                  ! ! intent(in)
   implicit none
   !---------------------------------------------------------------------------------------!


   !----- Local variables. ----------------------------------------------------------------!
   real(kind=4) :: ssfact
   !---------------------------------------------------------------------------------------!

   D0(1)                     = d0_grass
   D0(2:4)                   = d0_tree
   D0(5)                     = d0_grass
   D0(6:8)                   = d0_tree
   D0(9:11)                  = d0_tree
   D0(12:13)                 = d0_tree
   D0(14:15)                 = d0_tree
   D0(16)                    = d0_grass
   D0(17)                    = d0_tree
   D0(18)                    = d0_tree                                                                   ! CHANGED

   Vm_low_temp(1)            =  8.0             ! c4 grass
   Vm_low_temp(2)            =  8.0             ! early tropical
   Vm_low_temp(3)            =  8.0             ! mid tropical
   Vm_low_temp(4)            =  8.0             ! late tropical
   Vm_low_temp(5)            =  4.7137          ! c3 grass
   Vm_low_temp(6)            =  4.7137          ! northern pines ! 5.0
   Vm_low_temp(7)            =  4.7137          ! southern pines ! 5.0
   Vm_low_temp(8)            =  4.7137          ! late conifers  ! 5.0
   Vm_low_temp(9)            =  4.7137          ! early hardwoods
   Vm_low_temp(10)           =  4.7137          ! mid hardwoods
   Vm_low_temp(11)           =  4.7137          ! late hardwoods
   Vm_low_temp(12)           =  4.7137          ! c3 pasture
   Vm_low_temp(13)           =  4.7137          ! c3 crop
   Vm_low_temp(14)           =  8.0             ! c4 pasture
   Vm_low_temp(15)           =  8.0             ! c4 crop
   Vm_low_temp(16)           =  4.7137          ! subtropical C3 grass
   Vm_low_temp(17)           =  4.7137          ! Araucaria
   Vm_low_temp(18)           =  4.7137          ! Shrub                                                  ! CHANGED

   Vm_high_temp(1)           =  45.0 ! C4
   Vm_high_temp(2)           =  45.0 ! C3
   Vm_high_temp(3)           =  45.0 ! C3
   Vm_high_temp(4)           =  45.0 ! C3
   Vm_high_temp(5)           =  45.0 ! C3
   Vm_high_temp(6)           =  45.0 ! C3
   Vm_high_temp(7)           =  45.0 ! C3
   Vm_high_temp(8)           =  45.0 ! C3
   Vm_high_temp(9)           =  45.0 ! C3
   Vm_high_temp(10)          =  45.0 ! C3
   Vm_high_temp(11)          =  45.0 ! C3
   Vm_high_temp(12)          =  45.0 ! C3
   Vm_high_temp(13)          =  45.0 ! C3
   Vm_high_temp(14)          =  45.0 ! C4
   Vm_high_temp(15)          =  45.0 ! C4
   Vm_high_temp(16)          =  45.0 ! C3
   Vm_high_temp(17)          =  45.0 ! C3
   Vm_high_temp(18)          =  45.0 ! C3                                                                ! CHANGED

   !---------------------------------------------------------------------------------------!
   !    Vm_decay_e is the correction term for high and low temperatures when running the   !
   ! original ED-2.1 correction as in Moorcroft et al. (2001).                             !
   !    Vm_decay_a and Vm_decay_b are the correction terms when running the Collatz et al. !
   ! (1991).  When running Collatz, this is used for both C3 and C4 photosynthesis.        !
   !---------------------------------------------------------------------------------------!
   Vm_decay_e(1:18)          = 0.4     !                                          [    ---]              ! CHANGED
   Vm_decay_a(1:18)          = 220000. !                                          [  J/mol]              ! CHANGED
   Vm_decay_b(1:18)          = 690.    !                                          [J/mol/K]              ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Vm0 is the maximum photosynthesis capacity in �mol/m2/s.  Notice that depending   !
   ! on the size structure (SAS or Big Leaf), there is an addition factor multiplied.      !
   !---------------------------------------------------------------------------------------!
   !----- Find the additional factor to multiply Vm0. -------------------------------------!
   select case (ibigleaf)
   case (0)
      !----- SAS, use only the modification from the namelist. ----------------------------!
      ssfact = 1.0
   case (1)
      select case (iallom)
      case (0,1)
         ssfact = 3.0
      case default
         ssfact = 3.0
      end select
   end select
   !---- Define Vm0 for all PFTs. ---------------------------------------------------------!
   Vm0(1)                    = 12.500000 * ssfact * vmfact_c4
   Vm0(2)                    = 18.750000 * ssfact * vmfact_c3
   Vm0(3)                    = 12.500000 * ssfact * vmfact_c3
   Vm0(4)                    =  6.250000 * ssfact * vmfact_c3
   Vm0(5)                    = 18.300000 * ssfact * vmfact_c3
   Vm0(6)                    = 11.350000 * ssfact * vmfact_c3
   Vm0(7)                    = 11.350000 * ssfact * vmfact_c3
   Vm0(8)                    =  4.540000 * ssfact * vmfact_c3
   Vm0(9)                    = 20.387075 * ssfact * vmfact_c3
   Vm0(10)                   = 17.454687 * ssfact * vmfact_c3
   Vm0(11)                   =  6.981875 * ssfact * vmfact_c3
   Vm0(12:13)                = 18.300000 * ssfact * vmfact_c3
   Vm0(14:15)                = 12.500000 * ssfact * vmfact_c4
   Vm0(16)                   = 18.750000 * ssfact * vmfact_c3
   Vm0(17)                   = 15.625000 * ssfact * vmfact_c3
   Vm0(18)                   = 16.500000 * ssfact * vmfact_c3                                            ! CHANGED 
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Vm_hor is the Arrhenius "activation energy" divided by the universal gas         !
   ! constant.  Vm_q10 is the base for the Collatz approach.                               !
   !---------------------------------------------------------------------------------------!
   vm_hor(1:18)              = 3000.                                                                     ! CHANGED
   !----- Here we distinguish between C3 and C4 photosynthesis as in Collatz et al 91/92. -!
   vm_q10(1)                 = q10_c4
   vm_q10(2:13)              = q10_c3
   vm_q10(14:15)             = q10_c4
   vm_q10(16:18)             = q10_c3                                                                    ! CHANGED
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Dark_respiration_factor is the lower-case gamma in Moorcroft et al. (2001).        !
   !---------------------------------------------------------------------------------------!
   dark_respiration_factor(1)     = gamma_c4
   dark_respiration_factor(2)     = gamma_c3
   dark_respiration_factor(3)     = gamma_c3
   dark_respiration_factor(4)     = gamma_c3
   dark_respiration_factor(5)     = gamma_c3
   dark_respiration_factor(6)     = gamma_c3
   dark_respiration_factor(7)     = gamma_c3
   dark_respiration_factor(8)     = gamma_c3
   dark_respiration_factor(9)     = gamma_c3
   dark_respiration_factor(10)    = gamma_c3
   dark_respiration_factor(11)    = gamma_c3
   dark_respiration_factor(12)    = gamma_c3
   dark_respiration_factor(13)    = gamma_c3
   dark_respiration_factor(14)    = gamma_c4
   dark_respiration_factor(15)    = gamma_c4
   dark_respiration_factor(16)    = gamma_c3
   dark_respiration_factor(17)    = gamma_c3
   dark_respiration_factor(18)    = gamma_c3                                                              ! CHANGED
   !---------------------------------------------------------------------------------------!


   !----- Currently we assume most parameters to be the same as the Vm ones. --------------!
   Rd_low_temp (1:18) = Vm_low_temp (1:18)                                                                ! CHANGED
   Rd_high_temp(1:18) = Vm_high_temp(1:18)                                                                ! CHANGED
   Rd_decay_e  (1:18) = Vm_decay_e  (1:18)                                                                ! CHANGED
   Rd_hor      (1:18) = Vm_hor      (1:18)                                                                ! CHANGED
   Rd_q10      (1:18) = Vm_q10      (1:18)                                                                ! CHANGED
 
   !---------------------------------------------------------------------------------------!
   !    Respiration terms.  Here we must check whether this will run Foley-based or        !
   ! Collatz-based photosynthesis, because the respiration/Vm ratio is constant in the     !
   ! former but not in the latter.                                                         !
   ! Changed-KP                                                                            !
   !---------------------------------------------------------------------------------------!
   select case (iphysiol)
   case (0,1)
      !------ This should be simply gamma times Vm0. --------------------------------------!
      Rd0         (1:18) = dark_respiration_factor(1:18) * Vm0(1:18)

   case (2,3)
      !------------------------------------------------------------------------------------!
      !     Collatz-based method.  They have the gamma at 25 C, but because the Q10 bases  !
      ! are different for Vm and respiration (at least for C3), we must convert it to the  !
      ! ratio at 15C.                                                                      !
      !------------------------------------------------------------------------------------!
      Rd0         (1:18) = dark_respiration_factor(1:18) * Vm0(1:18)                       &
                         * Vm_q10(1:18) / Rd_q10(1:18)
   end select
   !---------------------------------------------------------------------------------------!



   !----- Define the stomatal slope (aka the M factor). -----------------------------------!
   stomatal_slope(1)         = mphoto_c4
   stomatal_slope(2)         = mphoto_trc3
   stomatal_slope(3)         = mphoto_trc3
   stomatal_slope(4)         = mphoto_trc3
   stomatal_slope(5)         = mphoto_trc3
   stomatal_slope(6)         = mphoto_tec3
   stomatal_slope(7)         = mphoto_tec3
   stomatal_slope(8)         = mphoto_tec3
   stomatal_slope(9)         = mphoto_tec3
   stomatal_slope(10)        = mphoto_tec3
   stomatal_slope(11)        = mphoto_tec3
   stomatal_slope(12)        = mphoto_trc3
   stomatal_slope(13)        = mphoto_trc3
   stomatal_slope(14)        = mphoto_c4
   stomatal_slope(15)        = mphoto_c4
   stomatal_slope(16)        = mphoto_trc3
   stomatal_slope(17)        = mphoto_tec3
   stomatal_slope(18)        = mphoto_trc3                                                               ! CHANGED
 
   !----- Define the stomatal slope (aka the b term, given in umol/m2/s). -----------------!
   cuticular_cond(1)         = bphoto_c4
   cuticular_cond(2)         = bphoto_blc3
   cuticular_cond(3)         = bphoto_blc3
   cuticular_cond(4)         = bphoto_blc3
   cuticular_cond(5)         = bphoto_blc3
   cuticular_cond(6)         = bphoto_nlc3
   cuticular_cond(7)         = bphoto_nlc3
   cuticular_cond(8)         = bphoto_nlc3
   cuticular_cond(9)         = bphoto_blc3
   cuticular_cond(10)        = bphoto_blc3
   cuticular_cond(11)        = bphoto_blc3
   cuticular_cond(12)        = bphoto_blc3
   cuticular_cond(13)        = bphoto_blc3
   cuticular_cond(14)        = bphoto_c4
   cuticular_cond(15)        = bphoto_c4
   cuticular_cond(16)        = bphoto_blc3
   cuticular_cond(17)        = bphoto_nlc3
   cuticular_cond(18)        = bphoto_blc3                                                               ! CHANGED

   quantum_efficiency(1)     = alpha_c4
   quantum_efficiency(2)     = alpha_c3
   quantum_efficiency(3)     = alpha_c3
   quantum_efficiency(4)     = alpha_c3
   quantum_efficiency(5)     = alpha_c3
   quantum_efficiency(6)     = alpha_c3
   quantum_efficiency(7)     = alpha_c3
   quantum_efficiency(8)     = alpha_c3
   quantum_efficiency(9)     = alpha_c3
   quantum_efficiency(10)    = alpha_c3
   quantum_efficiency(11)    = alpha_c3
   quantum_efficiency(12)    = alpha_c3
   quantum_efficiency(13)    = alpha_c3
   quantum_efficiency(14)    = alpha_c4
   quantum_efficiency(15)    = alpha_c4
   quantum_efficiency(16)    = alpha_c3
   quantum_efficiency(17)    = alpha_c3
   quantum_efficiency(18)    = alpha_c3                                                                 ! CHANGED

   !---------------------------------------------------------------------------------------!
   !     The KW parameter. Medvigy et al. (2009) and Moorcroft et al. (2001), and the      !
   ! namelist, give the number in m�/yr/kg_C_root.  Here we must convert it to             !
   !  m�/s/kg_C_root.                                                                      !
   !---------------------------------------------------------------------------------------!
   water_conductance(1)      = kw_grass / yr_sec
   water_conductance(2:4)    = kw_tree  / yr_sec
   water_conductance(5)      = kw_grass / yr_sec
   water_conductance(6:11)   = kw_tree  / yr_sec
   water_conductance(12:15)  = kw_grass / yr_sec
   water_conductance(16)     = kw_grass / yr_sec
   water_conductance(17)     = kw_tree  / yr_sec
   water_conductance(18)     = kw_tree  / yr_sec                                                       ! CHANGED - good for now
   !---------------------------------------------------------------------------------------!


   photosyn_pathway(1)       = 4
   photosyn_pathway(2:4)     = 3
   photosyn_pathway(5)       = 3
   photosyn_pathway(6:13)    = 3
   photosyn_pathway(14:15)   = 4
   photosyn_pathway(16:18)   = 3                                                                       ! CHANGED

   !----- Leaf width [m].  This controls the boundary layer conductance. ------------------!
   leaf_width( 1)    = lwidth_grass
   leaf_width( 2)    = lwidth_bltree
   leaf_width( 3)    = lwidth_bltree
   leaf_width( 4)    = lwidth_bltree
   leaf_width( 5)    = lwidth_grass
   leaf_width( 6)    = lwidth_nltree
   leaf_width( 7)    = lwidth_nltree
   leaf_width( 8)    = lwidth_nltree
   leaf_width( 9)    = lwidth_bltree
   leaf_width(10)    = lwidth_bltree
   leaf_width(11)    = lwidth_bltree
   leaf_width(12)    = lwidth_grass
   leaf_width(13)    = lwidth_grass
   leaf_width(14)    = lwidth_grass
   leaf_width(15)    = lwidth_grass
   leaf_width(16)    = lwidth_grass
   leaf_width(17)    = lwidth_nltree
   leaf_width(18)    = lwidth_bltree                                                                   ! CHANGED
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_pft_photo_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_decomp_params()
   use soil_coms   , only : slz                         ! ! intent(in)
   use grid_coms   , only : nzg                         ! ! intent(in)
   use consts_coms , only : yr_day                      & ! intent(in)
                          , t00                         ! ! intent(in)
   use decomp_coms , only : n_decomp_lim                & ! intent(in)
                          , decomp_scheme               & ! intent(in)
                          , resp_opt_water              & ! intent(out)
                          , resp_water_below_opt        & ! intent(out)
                          , resp_water_above_opt        & ! intent(out)
                          , resp_temperature_increase   & ! intent(out)
                          , N_immobil_supply_scale      & ! intent(out)
                          , cwd_frac                    & ! intent(out)
                          , r_fsc                       & ! intent(out)
                          , r_stsc                      & ! intent(out)
                          , r_ssc                       & ! intent(out)
                          , decay_rate_stsc             & ! intent(out)
                          , decay_rate_fsc              & ! intent(out)
                          , decay_rate_ssc              & ! intent(out)
                          , rh_lloyd_1                  & ! intent(out)
                          , rh_lloyd_2                  & ! intent(out)
                          , rh_lloyd_3                  & ! intent(out)
                          , rh_decay_low                & ! intent(out)
                          , rh_decay_high               & ! intent(out)
                          , rh_low_temp                 & ! intent(out)
                          , rh_high_temp                & ! intent(out)
                          , rh_decay_dry                & ! intent(out)
                          , rh_decay_wet                & ! intent(out)
                          , rh_dry_smoist               & ! intent(out)
                          , rh_wet_smoist               & ! intent(out)
                          , rh_active_depth             & ! intent(out)
                          , k_rh_active                 ! ! intent(out)

   resp_opt_water            = 0.8938
   resp_water_below_opt      = 5.0786
   resp_water_above_opt      = 4.5139
   resp_temperature_increase = 0.0757
   N_immobil_supply_scale    = 40.0 / yr_day
   cwd_frac                  = 0.2
   r_fsc                     = 1.0
   r_stsc                    = 0.3
   r_ssc                     = 1.0
   !---------------------------------------------------------------------------------------!
   ! MLO.  After talking to Paul, it seems the decay rate for the slow carbon pool is      !
   !       artificially high for when nitrogen limitation is turned on.  If it is turned   !
   !       off, however, then the slow carbon will disappear very quickly.  I don't want   !
   !       to mess other people's results, so I will change the rate only when             !
   !       decomp_scheme is 2, and only when nitrogen limitation is off.  I think this     !
   !       should be applied to all schemes, but I will let the users of these schemes to  !
   !       decide.                                                                         !
   !---------------------------------------------------------------------------------------!
   select case (decomp_scheme)
   case (0,1)
      decay_rate_fsc  =  11.0 / yr_day    ! former K2
      decay_rate_stsc =   4.5 / yr_day    ! former K1
      decay_rate_ssc  = 100.2 / yr_day    ! former K3
   case (2)
      decay_rate_fsc  =  11.0 / yr_day    ! former K2
      decay_rate_stsc =   4.5 / yr_day    ! former K1
      select case (n_decomp_lim)
      case (0)
         decay_rate_ssc  =   0.2 / yr_day ! former K3
      case (1)
         decay_rate_ssc  = 100.2 / yr_day ! former K3
      end select
   end select
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !      Parameters used for the Lloyd and Taylor (1994) temperature dependence.          !
   !---------------------------------------------------------------------------------------!
   rh_lloyd_1 = 308.56
   rh_lloyd_2 = 1./56.02
   rh_lloyd_3 = 227.15
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Parameters used for the ED-1.0/CENTURY based functions of temperature and soil   !
   ! moisture.                                                                             !
   !---------------------------------------------------------------------------------------!
   rh_decay_low   = 0.24
   rh_decay_high  = 0.60
   rh_low_temp    = 18.0 + t00
   rh_high_temp   = 45.0 + t00
   rh_decay_dry   = 12.0 ! 18.0
   rh_decay_wet   = 36.0 ! 36.0
   rh_dry_smoist  = 0.48 ! 0.36
   rh_wet_smoist  = 0.98 ! 0.96
   !---------------------------------------------------------------------------------------!


   !----- Determine the top layer to consider for heterotrophic respiration. --------------!
   select case (decomp_scheme)
   case (0,1)
      rh_active_depth = slz(nzg)
      k_rh_active     = nzg
   case (2)
      rh_active_depth = -0.20
      k_rh_loop: do k_rh_active=nzg-1,1,-1
        if (slz(k_rh_active) < rh_active_depth) exit k_rh_loop
      end do k_rh_loop
      k_rh_active = k_rh_active + 1
   end select
   !---------------------------------------------------------------------------------------!

   return

end subroutine init_decomp_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_pft_resp_params()
   use physiology_coms, only : iphysiol                  & ! intent(in)
                             , rrffact                   & ! intent(in)
                             , growthresp                ! ! intent(in)
   use pft_coms       , only : rd_low_temp               & ! intent(in)
                             , rd_high_temp              & ! intent(in)
                             , rd_decay_e                & ! intent(in)
                             , rd_hor                    & ! intent(in)
                             , rd_q10                    & ! intent(in)
                             , growth_resp_factor        & ! intent(out)
                             , leaf_turnover_rate        & ! intent(out)
                             , root_turnover_rate        & ! intent(out)
                             , storage_turnover_rate     & ! intent(out)
                             , root_respiration_factor   & ! intent(out)
                             , rrf_low_temp              & ! intent(out)
                             , rrf_high_temp             & ! intent(out)
                             , rrf_decay_e               & ! intent(out)
                             , rrf_hor                   & ! intent(out)
                             , rrf_q10                   ! ! intent(out)
   use decomp_coms    , only : f_labile                  ! ! intent(out)
   use consts_coms    , only : onesixth                  & ! intent(in)
                             , onethird                  & ! intent(in)
                             , t00                       ! ! intent(in)
   implicit none

   growth_resp_factor(1)          = growthresp
   growth_resp_factor(2)          = growthresp
   growth_resp_factor(3)          = growthresp
   growth_resp_factor(4)          = growthresp
   growth_resp_factor(5)          = onethird
   growth_resp_factor(6)          = 0.4503 ! 0.333
   growth_resp_factor(7)          = 0.4503
   growth_resp_factor(8)          = 0.4503 ! 0.333
   growth_resp_factor(9)          = 0.0
   growth_resp_factor(10)         = 0.0
   growth_resp_factor(11)         = 0.0
   growth_resp_factor(12)         = onethird
   growth_resp_factor(13)         = onethird
   growth_resp_factor(14)         = onethird
   growth_resp_factor(15)         = onethird
   growth_resp_factor(16)         = growthresp
   growth_resp_factor(17)         = 0.4503
   growth_resp_factor(18)         = 0.333                                                                ! CHANGED - good for now

   leaf_turnover_rate(1)          = 2.0
   leaf_turnover_rate(2)          = 1.0
   leaf_turnover_rate(3)          = 0.5
   leaf_turnover_rate(4)          = onethird
   leaf_turnover_rate(5)          = 2.0
   leaf_turnover_rate(6)          = onethird
   leaf_turnover_rate(7)          = onethird
   leaf_turnover_rate(8)          = onethird
   leaf_turnover_rate(9)          = 0.0
   leaf_turnover_rate(10)         = 0.0
   leaf_turnover_rate(11)         = 0.0
   leaf_turnover_rate(12)         = 2.0
   leaf_turnover_rate(13)         = 2.0
   leaf_turnover_rate(14)         = 2.0
   leaf_turnover_rate(15)         = 2.0
   leaf_turnover_rate(16)         = 2.0
   leaf_turnover_rate(17)         = onesixth
   leaf_turnover_rate(18)         = 1.0                                                                ! CHANGED

   !----- Root turnover rate.  ------------------------------------------------------------!
   root_turnover_rate(1)          = leaf_turnover_rate(1)
   root_turnover_rate(2)          = leaf_turnover_rate(2)
   root_turnover_rate(3)          = leaf_turnover_rate(3)
   root_turnover_rate(4)          = leaf_turnover_rate(4)
   root_turnover_rate(5)          = 2.0
   root_turnover_rate(6)          = 3.927218 ! 0.333
   root_turnover_rate(7)          = 4.117847 ! 0.333
   root_turnover_rate(8)          = 3.800132 ! 0.333
   root_turnover_rate(9)          = 5.772506
   root_turnover_rate(10)         = 5.083700
   root_turnover_rate(11)         = 5.070992
   root_turnover_rate(12)         = onethird
   root_turnover_rate(13)         = onethird
   root_turnover_rate(14)         = leaf_turnover_rate(14)
   root_turnover_rate(15)         = leaf_turnover_rate(15)
   root_turnover_rate(16)         = leaf_turnover_rate(16)
   root_turnover_rate(17)         = leaf_turnover_rate(17)
   root_turnover_rate(18)         = 0.44                                                                ! CHANGED

   storage_turnover_rate(1)       = onethird
   storage_turnover_rate(2)       = onesixth
   storage_turnover_rate(3)       = onesixth
   storage_turnover_rate(4)       = onesixth
   storage_turnover_rate(5)       = 0.00
   storage_turnover_rate(6)       = 0.00 ! 0.25
   storage_turnover_rate(7)       = 0.00 ! 0.25
   storage_turnover_rate(8)       = 0.00 ! 0.25
   storage_turnover_rate(9)       = 0.6243
   storage_turnover_rate(10)      = 0.6243
   storage_turnover_rate(11)      = 0.6243
   storage_turnover_rate(12)      = 0.00 ! 0.25
   storage_turnover_rate(13)      = 0.00 ! 0.25
   storage_turnover_rate(14)      = onethird
   storage_turnover_rate(15)      = onethird
   storage_turnover_rate(16)      = onethird
   storage_turnover_rate(17)      = onesixth
   storage_turnover_rate(18)      = 0.6243                                                              ! CHANGED

   f_labile(1:5)                  = 1.0
   f_labile(6:11)                 = 0.79
   f_labile(12:15)                = 1.0
   f_labile(16)                   = 1.0
   f_labile(17)                   = 0.79
   f_labile(18)                   = 0.79                                                                ! CHANGED

   !---------------------------------------------------------------------------------------!
   !    This variable sets the contribution of roots to respiration at the reference       !
   ! temperature of 15C.  Its units is �mol_CO2/kg_fine_roots/s.                           !
   !---------------------------------------------------------------------------------------!
   select case (iphysiol)
   case (0,1)
      !----- Arrhenius function. ----------------------------------------------------------!
      root_respiration_factor(1)     = 0.528 * rrffact
      root_respiration_factor(2:4)   = 0.528 * rrffact
      root_respiration_factor(5)     = 0.528 * rrffact
      root_respiration_factor(6:8)   = 0.528 * rrffact
      root_respiration_factor(9:11)  = 0.528 * rrffact
      root_respiration_factor(12:13) = 0.528 * rrffact
      root_respiration_factor(14:15) = 0.528 * rrffact
      root_respiration_factor(16)    = 0.528 * rrffact
      root_respiration_factor(17)    = 0.528 * rrffact
      root_respiration_factor(18)    = 0.528 * rrffact                                                   ! CHANGED
   case (2,3)
      !----- Collatz function. ------------------------------------------------------------!
      root_respiration_factor(1)     = 0.280 * rrffact
      root_respiration_factor(2:4)   = 0.280 * rrffact
      root_respiration_factor(5)     = 0.280 * rrffact
      root_respiration_factor(6:8)   = 0.280 * rrffact
      root_respiration_factor(9:11)  = 0.280 * rrffact
      root_respiration_factor(12:13) = 0.280 * rrffact
      root_respiration_factor(14:15) = 0.280 * rrffact
      root_respiration_factor(16)    = 0.280 * rrffact
      root_respiration_factor(17)    = 0.280 * rrffact
      root_respiration_factor(18)    = 0.280 * rrffact                                                   ! CHANGED
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Following Moorcroft et al. (2001), we use the same shape for both leaf and root   !
   ! respiration.                                                                          !
   ! CHANGED - KP                                                                          !  
   !---------------------------------------------------------------------------------------!
   !----- Temperature [�C] below which root metabolic activity begins to rapidly decline. -!
   rrf_low_temp(1:18)  = rd_low_temp(1:18)
   !----- Temperature [�C] above which root metabolic activity begins to rapidly decline. -!
   rrf_high_temp(1:18) = rd_high_temp(1:18)
   !----- Decay factor for the exponential correction. ------------------------------------!
   rrf_decay_e(1:18)   = rd_decay_e(1:18)
   !----- Exponent for Rr in the Arrhenius equation [K]. ----------------------------------!
   rrf_hor(1:18)       = rd_hor(1:18)
   !----- Base (Q10 term) for respiration in Collatz equation . ---------------------------!
   rrf_q10(1:18)       = rd_q10(1:18)
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_pft_resp_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This subroutine assigns some PFT-dependent parameters that control mortality rates.  !
!------------------------------------------------------------------------------------------!
subroutine init_pft_mort_params()

   use pft_coms    , only : mort0                      & ! intent(out)
                          , mort1                      & ! intent(out)
                          , mort2                      & ! intent(out)
                          , mort3                      & ! intent(out)
                          , cbr_severe_stress          & ! intent(out)
                          , rho                        & ! intent(out)
                          , seedling_mortality         & ! intent(out)
                          , treefall_s_gtht            & ! intent(out)
                          , treefall_s_ltht            & ! intent(out)
                          , fire_s_gtht                & ! intent(out)
                          , fire_s_ltht                & ! intent(out)
                          , plant_min_temp             & ! intent(out)
                          , frost_mort                 ! ! intent(out)
   use consts_coms , only : t00                        & ! intent(in)
                          , lnexp_max                  & ! intent(in)
                          , onethird                   & ! intent(in)
                          , twothirds                  ! ! intent(in)
   use ed_misc_coms, only : ibigleaf                   & ! intent(in)
                          , iallom                     ! ! intent(in)
   use disturb_coms, only : treefall_disturbance_rate  & ! intent(inout)
                          , time2canopy                ! ! intent(in)

   implicit none

   !----- Local variables. ----------------------------------------------------------------!
   real     :: aquad
   real     :: bquad
   real     :: cquad
   real     :: discr
   real     :: lambda_ref
   real     :: lambda_eff
   real     :: leff_neg
   real     :: leff_pos
   real     :: m3_slope
   real     :: m3_scale
   real     :: tdr_default
   !---------------------------------------------------------------------------------------!


   frost_mort(1)     = 3.0
   frost_mort(2:4)   = 3.0
   frost_mort(5)     = 3.0
   frost_mort(6:11)  = 3.0
   frost_mort(12:13) = 3.0
   frost_mort(14:15) = 3.0
   frost_mort(16:17) = 3.0
   frost_mort(18)    = 3.0                                                                                  ! CHANGED


   !---------------------------------------------------------------------------------------!
   !     The following variables control the density-dependent mortality rates.            !
   !---------------------------------------------------------------------------------------!
   mort0(1)  = -0.35 ! 0.0
   mort0(2)  = -0.35 ! 0.0
   mort0(3)  = -0.35 ! 0.0
   mort0(4)  = -0.35 ! 0.0
   mort0(5)  =  0.0
   mort0(6)  =  0.0
   mort0(7)  =  0.0
   mort0(8)  =  0.0
   mort0(9)  =  0.0
   mort0(10) =  0.0
   mort0(11) =  0.0
   mort0(12) =  0.0
   mort0(13) =  0.0
   mort0(14) = -0.35 ! 0.0
   mort0(15) = -0.35 ! 0.0
   mort0(16) = -0.35 ! 0.0
   mort0(17) = -0.35 ! 0.0
   mort0(18) =  0.0                                                                                         ! CHANGED

   mort1(1)  = 2.0 ! 10.0
   mort1(2)  = 2.0 ! 10.0
   mort1(3)  = 2.0 ! 10.0
   mort1(4)  = 2.0 ! 10.0
   mort1(5)  = 1.0
   mort1(6)  = 1.0
   mort1(7)  = 1.0
   mort1(8)  = 1.0
   mort1(9)  = 1.0
   mort1(10) = 1.0
   mort1(11) = 1.0
   mort1(12) = 1.0
   mort1(13) = 1.0
   mort1(14) = 2.0 ! 10.0
   mort1(15) = 2.0 ! 10.0
   mort1(16) = 2.0 ! 10.0
   mort1(17) = 2.0 ! 10.0
   mort1(18) = 1.0                                                                                          ! CHANGED

   mort2(1:17) = 15.0 ! 20.0
   mort2(2)    = 15.0 ! 20.0
   mort2(3)    = 15.0 ! 20.0
   mort2(4)    = 15.0 ! 20.0
   mort2(5)    = 20.0
   mort2(6)    = 20.0
   mort2(7)    = 20.0
   mort2(8)    = 20.0
   mort2(9)    = 20.0
   mort2(10)   = 20.0
   mort2(11)   = 20.0
   mort2(12)   = 20.0
   mort2(13)   = 20.0
   mort2(14)   = 15.0 ! 20.0
   mort2(15)   = 15.0 ! 20.0
   mort2(16)   = 15.0 ! 20.0
   mort2(17)   = 15.0 ! 20.0
   mort2(18)   = 20.0                                                                                       ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Variable mort3 controls the density-independent mortality rate due to ageing.     !
   ! This value is a constant in units of [fraction/year].                                 !
   !---------------------------------------------------------------------------------------!
   if (treefall_disturbance_rate >= 0.) then
      tdr_default               = 0.014
      m3_slope                  = 0.15
      m3_scale                  = treefall_disturbance_rate / tdr_default
   else
      treefall_disturbance_rate = abs(treefall_disturbance_rate)
      tdr_default               = 0.01137329
      m3_slope                  = 0.02939297
      m3_scale                  = treefall_disturbance_rate / tdr_default
   end if
   mort3(1)  = m3_scale * ( m3_slope * (1. - rho( 1) / rho( 4)) )
   mort3(2)  = m3_scale * ( m3_slope * (1. - rho( 2) / rho( 4)) )
   mort3(3)  = m3_scale * ( m3_slope * (1. - rho( 3) / rho( 4)) )
   mort3(4)  = 0.0
   mort3(5)  = 0.066
   mort3(6)  = 0.0033928
   mort3(7)  = 0.0043
   mort3(8)  = 0.0023568
   mort3(9)  = 0.006144
   mort3(10) = 0.003808
   mort3(11) = 0.00428
   mort3(12) = 0.066
   mort3(13) = 0.066
   mort3(14) = m3_scale * ( m3_slope * (1. - rho(14) / rho( 4)) )
   mort3(15) = m3_scale * ( m3_slope * (1. - rho(15) / rho( 4)) )
   mort3(16) = m3_scale * ( m3_slope * (1. - rho(16) / rho( 4)) )
   mort3(17) = 0.0043 ! Same as pines
   mort3(18) = 0.001                                                                                        ! CHANGED
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !      This is the default mortality for when the maximum carbon balance is negative.   !
   !  Default in ED-1.0 and ED-2.0 was to assume zero, an alternative is to assume maximum !
   !  mortality.                                                                           !
   !---------------------------------------------------------------------------------------!
   !cbr_severe_stress(1:18) = 0.0
   cbr_severe_stress(1:18) = log(epsilon(1.0)) / mort2(1:18)                                                ! CHANGED
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Here we check whether we need to re-calculate the treefall disturbance rate so it !
   ! is consistent with the time to reach the canopy.                                      !
   !---------------------------------------------------------------------------------------!
   if (treefall_disturbance_rate == 0.) then
      !------ No disturbance rate, set time to reach canopy to infinity. ------------------!
      time2canopy = huge(1.) 
      lambda_ref  = 0.
      lambda_eff  = 0.

   else
      lambda_ref = treefall_disturbance_rate

      if (time2canopy > 0.) then
         !---------------------------------------------------------------------------------!
         !     We are not going to knock down trees as soon as the patch is created;       !
         ! instead, we will wait until the patch age is older than time2canopy.  We want,  !
         ! however, to make the mean patch age to be 1/treefall_disturbance_rate.  The     !
         ! equation below can be retrieved by integrating the steady-state probability     !
         ! distribution function.  The equation is quadratic and the discriminant will     !
         ! never be zero and the treefall_disturbance_rate will be always positive because !
         ! the values of time2canopy and treefall_disturbance_rate have already been       !
         ! tested in ed_opspec.F90.                                                        !
         !---------------------------------------------------------------------------------!
         aquad    = time2canopy * time2canopy * lambda_ref  - 2. * time2canopy
         bquad    = 2. * time2canopy * lambda_ref - 2.
         cquad    = 2. * lambda_ref
         !------ Find the discriminant. ---------------------------------------------------!
         discr    = bquad * bquad - 4. * aquad * cquad
         leff_neg = - 0.5 * (bquad - sqrt(discr)) / aquad
         leff_pos = - 0.5 * (bquad + sqrt(discr)) / aquad
         !---------------------------------------------------------------------------------!
         !      Use the maximum value, but don't let the value to be too large otherwise   !
         ! the negative exponential will cause underflow.                                  !
         !---------------------------------------------------------------------------------!
         lambda_eff = min(lnexp_max,max(leff_neg,leff_pos))
      else
         lambda_eff = lambda_ref
      end if

   end if
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !    Print out the summary.                                                             !
   !---------------------------------------------------------------------------------------!
   write (unit=*,fmt='(a)')           '----------------------------------------'
   write (unit=*,fmt='(a)')           '  Treefall disturbance parameters:'
   write (unit=*,fmt='(a,1x,es12.5)') '  - LAMBDA_REF  =',lambda_ref
   write (unit=*,fmt='(a,1x,es12.5)') '  - LAMBDA_EFF  =',lambda_eff
   write (unit=*,fmt='(a,1x,es12.5)') '  - TIME2CANOPY =',time2canopy
   write (unit=*,fmt='(a)')           '----------------------------------------'
   !---------------------------------------------------------------------------------------!





   !---------------------------------------------------------------------------------------!
   !     Seedling mortality must be redefined for big leaf runs: this is necessary because !
   ! big leaf plants don't grow in diameter, but in "population".                          !
   !---------------------------------------------------------------------------------------!
   select case (ibigleaf)
   case (0)
      seedling_mortality(1)    = 0.95
      seedling_mortality(2:4)  = 0.95
      seedling_mortality(5)    = 0.95
      seedling_mortality(6:15) = 0.95
      seedling_mortality(16)   = 0.95
      seedling_mortality(17)   = 0.95
      seedling_mortality(18)   = 0.95                                                                          ! CHANGED
   case (1)
      select case (iallom)
      case (0,1)
         seedling_mortality(1)     = 0.9500
         seedling_mortality(2:4)   = onethird
         seedling_mortality(5)     = 0.9500
         seedling_mortality(6:8)   = onethird
         seedling_mortality(9:11)  = onethird
         seedling_mortality(12:16) = 0.9500
         seedling_mortality(17)    = onethird
         seedling_mortality(18)    = 0.9500                                                                    ! CHANGED
      case default
         seedling_mortality(1)     = 0.9500
         seedling_mortality(2:4)   = 0.4000
         seedling_mortality(5)     = 0.9500
         seedling_mortality(6:8)   = 0.4000
         seedling_mortality(9:11)  = 0.4000
         seedling_mortality(12:16) = 0.9500
         seedling_mortality(17)    = 0.4000
         seedling_mortality(18)    = 0.9500                                                                    ! CHANGED
      end select
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Treefall survivorship fraction.                                                  !
   !---------------------------------------------------------------------------------------!
   !----- Trees taller than treefall_hite_threshold. --------------------------------------!
   treefall_s_gtht(1:18)    = 0.0                                                                              ! CHANGED
   !----- Trees shorter than treefall_hite_threshold. -------------------------------------!
   treefall_s_ltht(1)       = 0.25
   treefall_s_ltht(2:4)     = 0.10
   treefall_s_ltht(5)       = 0.25
   treefall_s_ltht(6:11)    = 0.10
   treefall_s_ltht(12:15)   = 0.25
   treefall_s_ltht(16)      = 0.25
   treefall_s_ltht(17)      = 0.10
   treefall_s_ltht(18)      = 0.10                                                                             ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Fire survivorship fraction.                                                      !
   !---------------------------------------------------------------------------------------!
   !----- Trees taller than fire_hite_threshold. ------------------------------------------!
   fire_s_gtht(1:18)    = 0.0                                                                                  ! CHANGED
   !----- Trees shorter than fire_hite_threshold. -----------------------------------------!
   fire_s_ltht(1)       = 0.0
   fire_s_ltht(2:4)     = 0.0
   fire_s_ltht(5)       = 0.0
   fire_s_ltht(6:11)    = 0.0
   fire_s_ltht(12:15)   = 0.0
   fire_s_ltht(16)      = 0.0
   fire_s_ltht(17)      = 0.0
   fire_s_ltht(18)      = 0.0                                                                                  ! CHANGED
   !---------------------------------------------------------------------------------------!

   plant_min_temp(1:4)      = t00+2.5
   plant_min_temp(5:6)      = t00-80.0
   plant_min_temp(7)        = t00-10.0
   plant_min_temp(8)        = t00-60.0
   plant_min_temp(9)        = t00-80.0
   plant_min_temp(10:11)    = t00-20.0
   plant_min_temp(12:13)    = t00-80.0
   plant_min_temp(14:15)    = t00+2.5
   plant_min_temp(16)       = t00-20.0
   plant_min_temp(17)       = t00-15.0
   plant_min_temp(18)       = t00-80.0                                                                         ! CHANGED

   return
end subroutine init_pft_mort_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_pft_alloc_params()

   use pft_coms     , only : leaf_turnover_rate    & ! intent(in)
                           , is_tropical           & ! intent(in)
                           , is_grass              & ! intent(in)
                           , rho                   & ! intent(out)
                           , SLA                   & ! intent(out)
                           , horiz_branch          & ! intent(out)
                           , q                     & ! intent(out)
                           , qsw                   & ! intent(out)
                           , init_density          & ! intent(out)
                           , init_laimax           & ! intent(out)
                           , agf_bs                & ! intent(out)
                           , brf_wd                & ! intent(out)
                           , hgt_min               & ! intent(out)
                           , hgt_ref               & ! intent(out)
                           , hgt_max               & ! intent(out)
                           , min_dbh               & ! intent(out)
                           , dbh_crit              & ! intent(out)
                           , dbh_bigleaf           & ! intent(out)
                           , dbh_adult             & ! intent(out)
                           , min_bdead             & ! intent(out)
                           , bdead_crit            & ! intent(out)
                           , bleaf_adult           & ! intent(out)
                           , b1Ht                  & ! intent(out)
                           , b2Ht                  & ! intent(out)
                           , b1Bs_small            & ! intent(out)
                           , b2Bs_small            & ! intent(out)
                           , b1Bs_large            & ! intent(out)
                           , b2Bs_large            & ! intent(out)
                           , b1Ca                  & ! intent(out)
                           , b2Ca                  & ! intent(out)
                           , b1Rd                  & ! intent(out)
                           , b2Rd                  & ! intent(out)
                           , b1Vol                 & ! intent(out)
                           , b2Vol                 & ! intent(out)
                           , b1Bl_small            & ! intent(out)
                           , b2Bl_small            & ! intent(out)
                           , b1Bl_large            & ! intent(out)
                           , b2Bl_large            & ! intent(out)
                           , b1WAI                 & ! intent(out)
                           , b2WAI                 & ! intent(out)
                           , C2B                   & ! intent(out)
                           , sla_scale             & ! intent(out)
                           , sla_inter             & ! intent(out)
                           , sla_slope             & ! intent(out)
                           , sapwood_ratio         ! ! intent(out)
   use allometry    , only : h2dbh                 & ! function
                           , dbh2bd                & ! function
                           , size2bl               ! ! function
   use consts_coms  , only : onethird              & ! intent(in)
                           , twothirds             & ! intent(in)
                           , huge_num              & ! intent(in)
                           , pi1                   ! ! intent(in)
   use ed_max_dims  , only : n_pft                 & ! intent(in)
                           , str_len               ! ! intent(in)
   use ed_misc_coms , only : iallom                & ! intent(in)
                           , igrass                & ! intent(in)
                           , ibigleaf              ! ! intent(in)
   use detailed_coms, only : idetailed             ! ! intent(in)
   implicit none
   !----- Local variables. ----------------------------------------------------------------!
   integer                           :: ipft
   integer                           :: n
   real                              :: aux
   real                              :: init_density_grass
   real                              :: init_bleaf
   logical                           :: write_allom
   real                              :: bleaf_sapling
   !----- Constants shared by both bdead and bleaf (tropical PFTs) ------------------------!
   real                  , parameter :: a1          =  -1.981
   real                  , parameter :: b1          =   1.047
   real                  , parameter :: dcrit       = 100.0
   !----- Constants used by bdead only (tropical PFTs) ------------------------------------!
   real                  , parameter :: c1d         =   0.572
   real                  , parameter :: d1d         =   0.931
   real                  , parameter :: a2d         =  -1.086
   real                  , parameter :: b2d         =   0.876
   real                  , parameter :: c2d         =   0.604
   real                  , parameter :: d2d         =   0.871
   !----- Constants used by bleaf only (tropical PFTs) ------------------------------------!
   real                  , parameter :: c1l         =  -0.584
   real                  , parameter :: d1l         =   0.550
   real                  , parameter :: a2l         =  -4.111
   real                  , parameter :: b2l         =   0.605
   real                  , parameter :: c2l         =   0.848
   real                  , parameter :: d2l         =   0.438
   !---------------------------------------------------------------------------------------!
   !     MLO.   These are the new parameters obtained by adjusting a curve that is similar !
   !            to the modified Chave's equation to include wood density effect on the     !
   !            DBH->AGB allometry as described by:                                        ! 
   !                                                                                       !
   !            Baker, T. R., and co-authors, 2004: Variation in wood density determines   !
   !               spatial patterns in Amazonian forest biomass.  Glob. Change Biol., 10,  !
   !               545-562.                                                                !
   !                                                                                       !
   !     The "a" parameters were obtaining by splitting balive and bdead at the same ratio !
   ! as the original ED-2.1 allometry, and optimising a function of the form               !
   ! B? = (rho / a3) * exp [a1 + a2 * ln(DBH)]                                             !
   !     The "z" parameters were obtaining by using the original balive and computing      !
   ! bdead as the difference between the total biomass and the original balive.            !
   !---------------------------------------------------------------------------------------!
   real, dimension(3)    , parameter :: odead_small = (/-1.1138270, 2.4404830, 2.1806320 /)
   real, dimension(3)    , parameter :: odead_large = (/ 0.1362546, 2.4217390, 6.9483532 /)
   real, dimension(3)    , parameter :: ndead_small = (/-1.2639530, 2.4323610, 1.8018010 /)
   real, dimension(3)    , parameter :: ndead_large = (/-0.8346805, 2.4255736, 2.6822805 /)
   real, dimension(3)    , parameter :: nleaf       = (/ 0.0192512, 0.9749494, 2.5858509 /)
   real, dimension(2)    , parameter :: ncrown_area = (/ 0.1184295, 1.0521197            /)
   !----- Other constants. ----------------------------------------------------------------!
   character(len=str_len), parameter :: allom_file  = 'allom_param.txt'
   !---------------------------------------------------------------------------------------!



   !----- Check whether to print the allometry table or not. ------------------------------!
   write_allom = btest(idetailed,5)
   !---------------------------------------------------------------------------------------!


   !----- Carbon-to-biomass ratio of plant tissues. ---------------------------------------!
   C2B    = 2.0
   !---------------------------------------------------------------------------------------! 

   !---------------------------------------------------------------------------------------!
   !     Wood density.  Currently only tropical PFTs need it.  C3 grass density will be    !
   ! used only for branch area purposes.                                                   !
   !---------------------------------------------------------------------------------------!
   !---- [KIM] new tropical parameters. ---------------------------------------------------!
   rho(1)     = 0.20   ! 0.40
   rho(2)     = 0.53   ! 0.40
   rho(3)     = 0.71   ! 0.60
   rho(4)     = 0.90   ! 0.87
   rho(5)     = 0.20   ! Copied from C4 grass
   rho(6:11)  = 0.00   ! Currently not used
   rho(12:13) = 0.20
   rho(14:15) = 0.20
   rho(16)    = 0.20
   rho(17)    = 0.54
   rho(18)    = 0.00   ! Not used                                                                                    ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Specific leaf area [m� leaf / kg C].   For tropical PFTs, this is a turnover rate !
   ! defined by the slope, intercept and scale.                                            !
   !---------------------------------------------------------------------------------------!
   !----- Old parameters. -----------------------------------------------------------------!
   ! sla_scale =  1.0000
   ! sla_inter =  1.6923
   ! sla_slope = -0.3305
   !----- New parameters. -----------------------------------------------------------------!
   sla_scale =  0.1 * C2B
   sla_inter =  2.4
   sla_slope = -0.46

   !----- [KIM] - new tropical parameters. ------------------------------------------------!
   SLA( 1) = 22.7 !--value from Mike Dietze: mean: 22.7, median 19.1, 95% CI: 5.7, 78.6
   SLA( 2) = 10.0**(sla_inter + sla_slope * log10(12.0/leaf_turnover_rate( 2))) * sla_scale
   SLA( 3) = 10.0**(sla_inter + sla_slope * log10(12.0/leaf_turnover_rate( 3))) * sla_scale
   SLA( 4) = 10.0**(sla_inter + sla_slope * log10(12.0/leaf_turnover_rate( 4))) * sla_scale
   SLA( 5) = 22.0
   SLA( 6) =  6.0
   SLA( 7) =  9.0
   SLA( 8) = 10.0
   SLA( 9) = 30.0
   SLA(10) = 24.2
   SLA(11) = 60.0
   SLA(12) = 22.0
   SLA(13) = 22.0
   SLA(14) = 22.7 ! 10.0**(sla_inter + sla_slope * log10(12.0/leaf_turnover_rate(14))) * sla_scale
   SLA(15) = 22.7 ! 10.0**(sla_inter + sla_slope * log10(12.0/leaf_turnover_rate(15))) * sla_scale
   SLA(16) = 22.7 !--value from Mike Dietze: mean: 22.7, median 19.1, 95% CI: 5.7, 78.6
   SLA(17) = 10.0
   SLA(18) =  8.0                                                                                                 ! CHANGED

   !---------------------------------------------------------------------------------------!
   !    Fraction of vertical branches.  Values are from Poorter et al. (2006):             !
   !                                                                                       !
   !    Poorter, L.; Bongers, L.; Bongers, F., 2006: Architecture of 54 moist-forest tree  !
   ! species: traits, trade-offs, and functional groups. Ecology, 87, 1289-1301.           !
   ! For simplicity, we assume similar numbers for temperate PFTs.                         !
   !---------------------------------------------------------------------------------------!
   horiz_branch(1)     = 0.50
   horiz_branch(2)     = 0.57
   horiz_branch(3)     = 0.39
   horiz_branch(4)     = 0.61
   horiz_branch(5)     = 0.50
   horiz_branch(6:8)   = 0.61
   horiz_branch(9)     = 0.57
   horiz_branch(10)    = 0.39
   horiz_branch(11)    = 0.61
   horiz_branch(12:15) = 0.50
   horiz_branch(16)    = 0.50
   horiz_branch(17)    = 0.61
   horiz_branch(18)    = 0.50                                                                                     ! CHANGED
   !---------------------------------------------------------------------------------------!


   !----- Ratio between fine roots and leaves [kg_fine_roots/kg_leaves] -------------------!
   q(1)     = 1.0
   q(2)     = 1.0
   q(3)     = 1.0
   q(4)     = 1.0
   q(5)     = 1.0
   q(6)     = 0.3463 ! 1.0
   q(7)     = 0.3463 ! 1.0
   q(8)     = 0.3463 ! 1.0
   q(9)     = 1.1274
   q(10)    = 1.1274
   q(11)    = 1.1274
   q(12:15) = 1.0
   q(16)    = 1.0
   q(17)    = 1.0
   q(18)    = 6.0                                                                                                 ! CHANGED

   sapwood_ratio(1:18) = 3900.0                                                                                   ! CHANGED

   !---------------------------------------------------------------------------------------!
   !    Finding the ratio between sapwood and leaves [kg_sapwood/kg_leaves]                !
   !                                                                                       !
   !    KIM: ED1/ED2 codes and Moorcroft et al. had the incorrect ratio.  Since the mid-   !
   ! latitude parameters have been optimized using the wrong SLA, we keep the bug until    !
   ! it is updated...                                                                      !
   !---------------------------------------------------------------------------------------!
   qsw(1:4)    = SLA(1:4)   / sapwood_ratio(1:4)    !new is SLA(1:4)/(3900.0*2.0/1000.0)
   qsw(5:13)   = SLA(5:13)  / sapwood_ratio(5:13)
   qsw(14:15)  = SLA(14:15) / sapwood_ratio(14:15)  !new is SLA(14:15)(3900.0*2.0/1000.0)
   qsw(16)     = SLA(16)    / sapwood_ratio(16)
   qsw(17)     = SLA(17)    / sapwood_ratio(17)
   qsw(18)     = SLA(18)    / sapwood_ratio(18)                                                                   ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Initial density of plants, for near-bare-ground simulations [# of individuals/m2]  !
   !---------------------------------------------------------------------------------------!
   if (igrass==1) then
      init_density_grass = 1.
   else
      init_density_grass = 0.1
   end if
   init_density(1)     = init_density_grass
   init_density(2:4)   = 0.1
   init_density(5)     = 0.1
   init_density(6:8)   = 0.1
   init_density(9:11)  = 0.1
   init_density(12:13) = 0.1
   init_density(14:15) = 0.1
   init_density(16)    = init_density_grass
   init_density(17)    = 0.1
   init_density(18)    = 0.1                                                                                      ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !   DBH/height allometry parameters.                                                    !
   !                                                                                       !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !   WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!    !
   !                                                                                       !
   !   b1Ht, b2Ht, and hgt_ref are parameters that have different meaning for tropical and !
   ! temperate PFTs, and the meaning for tropical PFTs depends on IALLOM...These parameters!
   ! also have a different meaning for shrub                                               !
   !---------------------------------------------------------------------------------------!
   !----- DBH-height allometry intercept [m]. ---------------------------------------------!
   b1Ht(1:4)   = 0.0
   b1Ht(5)     = 0.4778
   b1Ht(6)     = 27.14
   b1Ht(7)     = 27.14
   b1Ht(8)     = 22.79
   b1Ht(9)     = 22.6799
   b1Ht(10)    = 25.18
   b1Ht(11)    = 23.3874
   b1Ht(12:13) = 0.4778
   b1Ht(14:15) = 0.0
   b1Ht(16)    = 0.0
   b1Ht(17)    = 0.0
   b1Ht(18)    = 4.7562                                                                                            ! CHANGEd
   !----- DBH-height allometry slope [1/cm]. ----------------------------------------------!
   b2Ht(1:4)   =  0.00
   b2Ht(5)     = -0.75
   b2Ht(6)     = -0.03884
   b2Ht(7)     = -0.03884
   b2Ht(8)     = -0.04445 
   b2Ht(9)     = -0.06534
   b2Ht(10)    = -0.04964
   b2Ht(11)    = -0.05404
   b2Ht(12:13) = -0.75
   b2Ht(14:15) =  0.00
   b2Ht(16)    =  0.00
   b2Ht(17)    =  0.00
   b2Ht(18)    = -0.002594                                                                                        ! CHANGED
   !----- Reference height for diameter/height allometry. ---------------------------------!
   hgt_ref(1:5)   = 0.0
   hgt_ref(6:11)  = 1.3
   hgt_ref(12:15) = 0.0
   hgt_ref(16)    = 0.0
   hgt_ref(17)    = 0.0
   hgt_ref(18)    = 0.0                                                                                           ! CHANGED
   !----- Assign the parameters for tropical PFTs depending on the chosen allometry. ------!
   select case (iallom)
   case (0:1)
      !------------------------------------------------------------------------------------!
      !     Use the original ED allometry, based on an unpublished paper by O'Brien et al. !
      ! (1999).  There is an older reference from a similar group of authors, but it is    !
      ! not the allometry used by ED.                                                      !
      !------------------------------------------------------------------------------------!
      do ipft=1,n_pft
         if (is_tropical(ipft)) then
            !----- Regular log-log fit, b1 is the intercept and b2 is the slope. ----------!
            b1Ht   (ipft) = 0.37 * log(10.0)
            b2Ht   (ipft) = 0.64
            !----- hgt_ref is not used. ---------------------------------------------------!
            ! hgt_ref(ipft) = 0.0
         end if
      end do
   case default
      !------------------------------------------------------------------------------------!
      !     Use the allometry proposed by:                                                 !
      !                                                                                    !
      ! Poorter, L., L. Bongers, F. Bongers, 2006: Architecture of 54 moist-forest tree    !
      !    species: traits, trade-offs, and functional groups.  Ecology, 87, 1289-1301.    !
      !                                                                                    !
      !------------------------------------------------------------------------------------!
      do ipft=1,n_pft
         if (is_tropical(ipft)) then
            !----- b1Ht is their "a" and b2Ht is their "b". -------------------------------!
            b1Ht   (ipft) = 0.0352
            b2Ht   (ipft) = 0.694
            !----- hgt_ref is their "Hmax". -----------------------------------------------!
            hgt_ref(ipft) = 61.7
         end if
      end do
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Minimum and maximum height allowed for each cohort.                                !
   !---------------------------------------------------------------------------------------!
   hgt_min(1)     = 0.50
   hgt_min(2:4)   = 0.50
   hgt_min(5)     = 0.15
   hgt_min(6)     = 1.50
   hgt_min(7)     = 1.50
   hgt_min(8)     = 1.50
   hgt_min(9)     = 1.50
   hgt_min(10)    = 1.50
   hgt_min(11)    = 1.50
   hgt_min(12)    = 0.15
   hgt_min(13)    = 0.15
   hgt_min(14)    = 0.50
   hgt_min(15)    = 0.50
   hgt_min(16)    = 0.50
   hgt_min(17)    = 0.50
   hgt_min(18)    = 0.25                                                                                          ! CHANGED
   !----- Maximum Height. -----------------------------------------------------------------!
   hgt_max( 1) = 1.50
   hgt_max( 2) = 35.0
   hgt_max( 3) = 35.0
   hgt_max( 4) = 35.0
   hgt_max( 5) = 0.95  * b1Ht( 5)
   hgt_max( 6) = 0.999 * b1Ht( 6)
   hgt_max( 7) = 0.999 * b1Ht( 7)
   hgt_max( 8) = 0.999 * b1Ht( 8)
   hgt_max( 9) = 0.999 * b1Ht( 9)
   hgt_max(10) = 0.999 * b1Ht(10)
   hgt_max(11) = 0.999 * b1Ht(11)
   hgt_max(12) = 0.95  * b1Ht(12)
   hgt_max(13) = 0.95  * b1Ht(13)
   hgt_max(14) = 1.50
   hgt_max(15) = 1.50
   hgt_max(16) = 1.50
   hgt_max(17) = 35.0
   hgt_max(18) = 2.50                                                                                             ! CHANGED - discuss with others
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------! 
   !   MIN_DBH     -- minimum DBH allowed for the PFT.                                     !
   !   DBH_CRIT    -- minimum DBH that brings the PFT to its tallest possible height.      !
   !   DBH_ADULT   -- minimum DBH for the tree to be considered adult (used only when      !
   !                  IALLOM = 3 and PFT is tropical).                                     !
   !---------------------------------------------------------------------------------------!
   do ipft=1,n_pft
      min_dbh    (ipft) = h2dbh(hgt_min(ipft),ipft)
      dbh_crit   (ipft) = h2dbh(hgt_max(ipft),ipft)
      dbh_adult  (ipft) = 10.0
   end do
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    This is the typical DBH that all big leaf plants will have.  Because the big-leaf  !
   ! ED doesn't really solve individuals, the typical DBH should be one that makes a good  !
   ! ratio between LAI and biomass.  This is a tuning parameter and right now the initial  !
   ! guess is about 1/3 of the critical DBH for trees.                                     !
   !---------------------------------------------------------------------------------------!
   select case (iallom)
   case (0,1)
      dbh_bigleaf( 1) = dbh_crit( 1)
      dbh_bigleaf( 2) = dbh_crit( 2)
      dbh_bigleaf( 3) = dbh_crit( 3)
      dbh_bigleaf( 4) = dbh_crit( 4)
      dbh_bigleaf( 5) = dbh_crit( 5)
      dbh_bigleaf( 6) = dbh_crit( 6)
      dbh_bigleaf( 7) = dbh_crit( 7)
      dbh_bigleaf( 8) = dbh_crit( 8)
      dbh_bigleaf( 9) = dbh_crit( 9)
      dbh_bigleaf(10) = dbh_crit(10)
      dbh_bigleaf(11) = dbh_crit(11)
      dbh_bigleaf(12) = dbh_crit(12)
      dbh_bigleaf(13) = dbh_crit(13)
      dbh_bigleaf(14) = dbh_crit(14)
      dbh_bigleaf(15) = dbh_crit(15)
      dbh_bigleaf(16) = dbh_crit(16)
      dbh_bigleaf(17) = dbh_crit(17)
      dbh_bigleaf(18) = dbh_crit(18)                                                                           ! CHANGED
   case default
      dbh_bigleaf( 1) = dbh_crit( 1)
      dbh_bigleaf( 2) = 29.69716
      dbh_bigleaf( 3) = 31.41038
      dbh_bigleaf( 4) = 16.67251
      dbh_bigleaf( 5) = dbh_crit( 5)
      dbh_bigleaf( 6) = dbh_crit( 6) * onethird
      dbh_bigleaf( 7) = dbh_crit( 7) * onethird
      dbh_bigleaf( 8) = dbh_crit( 8) * onethird
      dbh_bigleaf( 9) = dbh_crit( 9) * onethird
      dbh_bigleaf(10) = dbh_crit(10) * onethird
      dbh_bigleaf(11) = dbh_crit(11) * onethird
      dbh_bigleaf(12) = dbh_crit(12)
      dbh_bigleaf(13) = dbh_crit(13)
      dbh_bigleaf(14) = dbh_crit(14)
      dbh_bigleaf(15) = dbh_crit(15)
      dbh_bigleaf(16) = dbh_crit(16)
      dbh_bigleaf(17) = 30.0
      dbh_bigleaf(18) = dbh_crit(18) * onethird                                                               ! CHANGED
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     DBH-leaf and dead biomass allometries.  We first define them for the default,     !
   ! size-and-age structure case, but we may overwrite them depending on the allometry.    !
   !---------------------------------------------------------------------------------------!
   !----- DBH-leaf allometry intercept [kg leaf biomass / plant * cm^(-b2Bl)]. ------------!
   b1Bl_small(1:4)   = 0.0
   b1Bl_small(5)     = 0.08
   b1Bl_small(6)     = 0.024
   b1Bl_small(7)     = 0.024
   b1Bl_small(8)     = 0.0454
   b1Bl_small(9)     = 0.0129
   b1Bl_small(10)    = 0.048
   b1Bl_small(11)    = 0.017
   b1Bl_small(12:13) = 0.08
   b1Bl_small(14:15) = 0.0
   b1Bl_small(16)    = 0.0
   b1Bl_small(17)    = 0.0
   b1Bl_small(18)    = 0.000002582                                                                             ! CHANGED
   !-----  DBH-leaf allometry slope [dimensionless]. --------------------------------------!
   b2Bl_small(1:4)   = 0.0
   b2Bl_small(5)     = 1.0
   b2Bl_small(6)     = 1.899
   b2Bl_small(7)     = 1.899
   b2Bl_small(8)     = 1.6829
   b2Bl_small(9)     = 1.7477
   b2Bl_small(10)    = 1.455
   b2Bl_small(11)    = 1.731
   b2Bl_small(12:13) = 1.0
   b2Bl_small(14:15) = 0.0
   b2Bl_small(16)    = 0.0
   b2Bl_small(17)    = 0.0
   b2Bl_small(18)    = 2.746                                                                                     ! CHANGED
   !----- The default coefficients for large trees are the same as the small ones. --------!
   b1Bl_large(:)     = b1Bl_small(:)
   b2Bl_large(:)     = b2Bl_small(:)
   !---------------------------------------------------------------------------------------!

   !------- Fill in the tropical PFTs, which are functions of wood density. ---------------!
   do ipft=1,n_pft
      if (is_tropical(ipft)) then
         select case(iallom)
         case (0,1)
            !------------------------------------------------------------------------------!
            !      ED-2.0 allometry, based on:                                             !
            !                                                                              !
            !   Saldarriaga, J. G., D. C. West, M. L. Tharp, and C. Uhl.  Long-term        !
            !      chronosequence of forest succession in the upper Rio Negro of Colombia  !
            !      and Venezuela.  J. Ecol., 76, 4, 938-958, 1988.                         !
            !------------------------------------------------------------------------------!
            b1Bl_small (ipft) = exp(a1 + c1l * b1Ht(ipft) + d1l * log(rho(ipft)))
            aux               = ( (a2l - a1) + b1Ht(ipft) * (c2l - c1l) + log(rho(ipft))   &
                                * (d2l - d1l) ) * (1.0/log(dcrit))
            b2Bl_small (ipft) = C2B * b2l + c2l * b2Ht(ipft) + aux
            b1Bl_large (ipft) = b1Bl_small(ipft)
            b2Bl_large (ipft) = b2Bl_small(ipft)
            bleaf_adult(ipft) = b1Bl_large(ipft) / C2B * dbh_adult(ipft) ** b2Bl_large(ipft)
            !------------------------------------------------------------------------------!
         case (2)
            !------------------------------------------------------------------------------!
            !     ED-2.1 allometry, based on:                                              !
            !                                                                              !
            !   Calvo-Alvarado, J. C., N. G. McDowell, and R. H. Waring.  Tree Physiol.,   !
            !      28, 11, 1601-1608, 2008.                                                !
            !                                                                              !
            !   Cole, T. G., J. J. Ewel.  Allometric equations for four valuable tropical  !
            !      tree species.  Forest Ecol. Manag., 229, 1--3, 351-360, 2006.           !
            !------------------------------------------------------------------------------!
            b1Bl_small (ipft) = C2B * exp(nleaf(1)) * rho(ipft) / nleaf(3)
            b2Bl_small (ipft) = nleaf(2)
            b1Bl_large (ipft) = b1Bl_small(ipft)
            b2Bl_large (ipft) = b2Bl_small(ipft)
            bleaf_adult(ipft) = b1Bl_large(ipft) / C2B * dbh_adult(ipft) ** b2Bl_large(ipft)
            !------------------------------------------------------------------------------!
         case (3)
            !------------------------------------------------------------------------------!
            !     ED-2.2 allometry.  For large trees, it is based on:                      !
            !                                                                              !
            !   Lescure, J.-P., H. Puig, B. Riera, D. Leclerc, A. Beekman, and             !
            !      A. Beneteau.  La phytomasse epigee d'une foret dense en Guyane          !
            !      Francaise.  Acta Oecol. - Oec. Gen., 4, 3, 237-251, 1983.               !
            !                                                                              !
            !   Further modified to scale the leaf biomass by SLA.  For smaller trees, the !
            !      biomass is a log-linear interpolation from 20gC/plant at minimum size   !
            !      (scaled by SLA relative to mid-successional) and Lescure's allometry at !
            !      minimum adult size.                                                     !
            !------------------------------------------------------------------------------!
            b1Bl_large (ipft) = 0.00873 * SLA(3) / SLA(ipft)
            b2Bl_large (ipft) = 2.1360
            bleaf_adult(ipft) = b1Bl_large(ipft) / C2B * dbh_adult(ipft) ** b2Bl_large(ipft)
            bleaf_sapling     = 0.02 * C2B * SLA(3) / SLA(ipft)
            b2Bl_small (ipft) = log( bleaf_adult(ipft) / bleaf_sapling )                   &
                              / log( dbh_adult  (ipft) / min_dbh(ipft) )
            b1Bl_small (ipft) = bleaf_adult(ipft) * C2B                                    &
                              / dbh_adult(ipft) ** b2Bl_small(ipft)
            !------------------------------------------------------------------------------!
         end select
      else
         !---------------------------------------------------------------------------------!
         !     Calculate the leaf biomass at minimum adult size.                           !
         !---------------------------------------------------------------------------------!
         bleaf_adult(ipft) = b1Bl_large(ipft) / C2B * dbh_adult(ipft) ** b2Bl_large(ipft)
         !---------------------------------------------------------------------------------!
      end if
      !------------------------------------------------------------------------------------!
   end do
   !----- DBH-stem allometry intercept [kg stem biomass / plant * cm^(-b2Bs)] -------------!
   b1Bs_small(1:4)   = 0.0 
   b1Bs_small(5)     = 1.0e-5
   b1Bs_small(6)     = 0.147
   b1Bs_small(7)     = 0.147
   b1Bs_small(8)     = 0.1617
   b1Bs_small(9)     = 0.02648
   b1Bs_small(10)    = 0.1617
   b1Bs_small(11)    = 0.235
   b1Bs_small(12:13) = 1.0e-5
   b1Bs_small(14:15) = 0.0 
   b1Bs_small(16)    = 0.0 
   b1Bs_small(17)    = 0.0
   b1Bs_small(18)    = 0.00000005709                                                                               ! CHANGED
   !----- DBH-stem allometry slope [dimensionless]. ---------------------------------------!
   b2Bs_small(1:4)   = 0.0
   b2Bs_small(5)     = 1.0
   b2Bs_small(6)     = 2.238
   b2Bs_small(7)     = 2.238
   b2Bs_small(8)     = 2.1536
   b2Bs_small(9)     = 2.95954
   b2Bs_small(10)    = 2.4572
   b2Bs_small(11)    = 2.2518
   b2Bs_small(12:13) = 1.0
   b2Bs_small(14:15) = 0.0
   b2Bs_small(16)    = 0.0
   b2Bs_small(17)    = 0.0
   b2Bs_small(18)    = 4.149                                                                                        ! CHANGED
   !---------------------------------------------------------------------------------------!
   !     The temperate PFTs use the same b1Bs and b2Bs for small and big trees, copy       !
   ! the values.                                                                           !
   !---------------------------------------------------------------------------------------!
   b1Bs_large(:) = b1Bs_small(:)
   b2Bs_large(:) = b2Bs_small(:)
   !------- Fill in the tropical PFTs, which are functions of wood density. ---------------!
   do ipft = 1, n_pft
      if (is_tropical(ipft)) then
         select case (iallom)
         case (0)
            !---- ED-2.1 allometry. -------------------------------------------------------!
            b1Bs_small(ipft) = exp(a1 + c1d * b1Ht(ipft) + d1d * log(rho(ipft)))
            b1Bs_large(ipft) = exp(a1 + c1d * log(hgt_max(ipft)) + d1d * log(rho(ipft)))

            aux              = ( (a2d - a1) + b1Ht(ipft) * (c2d - c1d) + log(rho(ipft))    &
                               * (d2d - d1d)) * (1.0/log(dcrit))
            b2Bs_small(ipft) = C2B * b2d + c2d * b2Ht(ipft) + aux

            aux              = ( (a2d - a1) + log(hgt_max(ipft)) * (c2d - c1d)             &
                               + log(rho(ipft)) * (d2d - d1d)) * (1.0/log(dcrit))
            b2Bs_large(ipft) = C2B * b2d + aux

         case (1)
            !---- Based on modified Chave et al. (2001) allometry. ------------------------!
            b1Bs_small(ipft) = C2B * exp(odead_small(1)) * rho(ipft) / odead_small(3)
            b2Bs_small(ipft) = odead_small(2)
            b1Bs_large(ipft) = C2B * exp(odead_large(1)) * rho(ipft) / odead_large(3)
            b2Bs_large(ipft) = odead_large(2)

         case default
            !---- Based an alternative modification of Chave et al. (2001) allometry. -----!
            b1Bs_small(ipft) = C2B * exp(ndead_small(1)) * rho(ipft) / ndead_small(3)
            b2Bs_small(ipft) = ndead_small(2)
            b1Bs_large(ipft) = C2B * exp(ndead_large(1)) * rho(ipft) / ndead_large(3)
            b2Bs_large(ipft) = ndead_large(2)

         end select
      end if
      !------------------------------------------------------------------------------------!
   end do
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     In case we run big leaf model with IALLOM set to 0 or 1, we must change some of   !
   ! the allometric parameters.                                                            !
   ! CHANGED-KP                                                                            ! 
   !---------------------------------------------------------------------------------------!
   if (ibigleaf == 1 .and. (iallom == 0 .or. iallom == 1)) then
      b1Bl_small(    1)  = 0.04538826
      b1Bl_small(    2)  = 0.07322115
      b1Bl_small(    3)  = 0.07583497
      b1Bl_small(    4)  = 0.08915847
      b1Bl_small(14:16)  = 0.04538826
      b1Bl_small(   17)  = 0.07322115
      b1Bl_small(   18)  = 0.07322115
      
      b2Bl_small(    1)  = 1.316338
      b2Bl_small(    2)  = 1.509083
      b2Bl_small(    3)  = 1.646576
      b2Bl_small(    4)  = 1.663773
      b2Bl_small(14:16)  = 1.316338
      b2Bl_small(   17)  = 1.509083
      b2Bl_small(   18)  = 1.509083
      
      b1Bs_small(    1)  = 0.05291854
      b1Bs_small(    2)  = 0.15940854
      b1Bs_small(    3)  = 0.21445616
      b1Bs_small(    4)  = 0.26890751
      b1Bs_small(14:16)  = 0.05291854
      b1Bs_small(   17)  = 0.15940854
      b1Bs_small(   18)  = 0.15940854      

      b2Bs_small(    1)  = 3.706955
      b2Bs_small(    2)  = 2.342587
      b2Bs_small(    3)  = 2.370640
      b2Bs_small(    4)  = 2.254336
      b2Bs_small(14:16)  = 3.706955
      b2Bs_small(   17)  = 2.342587
      b2Bs_small(   18)  = 2.342587      

      b1Bl_large    (:)  = b1Bl_small(:)
      b2Bl_large    (:)  = b2Bl_small(:)
      b1Bs_large    (:)  = b1Bs_small(:)
      b2Bs_large    (:)  = b2Bs_small(:)
   end if
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Fill in variables tha are derived from bdead allometry.                           !
   !---------------------------------------------------------------------------------------!
   do ipft = 1, n_pft
      !------------------------------------------------------------------------------------!
      ! -- MIN_BDEAD is the minimum structural biomass possible.  This is used in the      !
      !    initialisation only, to prevent cohorts to be less than the minimum size due to !
      !    change in allometry.                                                            !
      ! -- BDEAD_CRIT corresponds to BDEAD when DBH is exactly at DBH_CRIT.  This is       !
      !    used to determine which b1Bs/b2Bs pair to use.                                  !
      !------------------------------------------------------------------------------------!
      min_bdead (ipft) = dbh2bd(min_dbh (ipft),ipft)
      bdead_crit(ipft) = dbh2bd(dbh_crit(ipft),ipft)
      !------------------------------------------------------------------------------------!
   end do
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     DBH-crown allometry.  Here we use Dietze and Clark (2008) parameters for the      !
   ! temperate PFTs and Poorter et al. (2006) for the tropical PFTs.  The Poorter et al.   !
   ! coefficients are converted to be functions of DBH rather than height.                 !
   !---------------------------------------------------------------------------------------!
   !----- Intercept. ----------------------------------------------------------------------!
   b1Ca(1:4)   = exp(-1.853) * exp(b1Ht(1:4)) ** 1.888
   b1Ca(5:13)  = 2.490154
   b1Ca(14:17) = exp(-1.853) * exp(b1Ht(14:17)) ** 1.888
   b1Ca(18)    = 0.0000635                                                                                  ! CHANGED
   !----- Slope.  -------------------------------------------------------------------------!
   b2Ca(1:4)   = b2Ht(1:4) * 1.888
   b2Ca(5:13)  = 0.8068806
   b2Ca(14:17) = b2Ht(14:17) * 1.888
   b2Ca(18)    = 2.18                                                                                        ! CHANGED
   !------ Allometric coefficents. --------------------------------------------------------!
   select case (iallom)
   case (0,1)
      !----- Original ED-2.1 --------------------------------------------------------------!
      do ipft=1,n_pft
         if (is_tropical(ipft)) then
            b1Ca(ipft) = exp(-1.853) * exp(b1Ht(ipft)) ** 1.888
            b2Ca(ipft) = b2Ht(ipft) * 1.888
         end if
      end do
   case default
      !----- Fitted values obtained using Poorter h->DBH to obtain function of DBH. -------!
      do ipft=1,n_pft
         if (is_tropical(ipft)) then
            b1Ca(ipft) = exp(ncrown_area(1))
            b2Ca(ipft) = ncrown_area(2)
         end if
      end do
   end select
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Use the equation by:                                                               !
   !    Ahrends, B., C. Penne, O. Panferov, 2010: Impact of target diameter harvesting on  !
   !        spatial and temporal pattern of drought risk in forest ecosystems under        !
   !        climate change conditions.  The Open Geography Journal, 3, 91-102  (they       !
   !        didn't develop the allometry, but the original reference is in German...)      !
   !---------------------------------------------------------------------------------------!
   !----- Intercept. ----------------------------------------------------------------------!
   b1WAI(1)     = 0.0192 * 0.5 ! Tiny WAI for grasses
   b1WAI(2:4)   = 0.0192 * 0.5 ! Broadleaf
   b1WAI(5)     = 0.0          ! Tiny WAI for grasses
   b1WAI(6:8)   = 0.0553 * 0.5 ! Needleleaf
   b1WAI(9:11)  = 0.0192 * 0.5 ! Broadleaf
   b1WAI(12:13) = 0.0          ! Tiny WAI for grasses
   b1WAI(14:16) = 0.0192 * 0.5 ! Tiny WAI for grasses
   b1WAI(17)    = 0.0553 * 0.5 ! Needleleaf
   b1WAI(18)    = 0.0192 * 0.5 ! Broadleaf                                                                  ! CHANGED
   !----- Slope. --------------------------------------------------------------------------!
   b2WAI(1)     = 2.0947       ! Tiny WAI for grasses
   b2WAI(2:4)   = 2.0947       ! Broadleaf
   b2WAI(5)     = 1.0          ! Tiny WAI for grasses
   b2WAI(6:8)   = 1.9769       ! Needleleaf
   b2WAI(9:11)  = 2.0947       ! Broadleaf
   b2WAI(12:13) = 1.0          ! Tiny WAI for grasses
   b2WAI(14:16) = 2.0947       ! Tiny WAI for grasses
   b2WAI(17)    = 1.9769       ! Needleleaf
   b2WAI(18)    = 1.4648       ! Broadleaf adjusted for shrub DBH                                           ! CHANGED
   !---------------------------------------------------------------------------------------!



   !----- Fraction of structural stem that is assumed to be above ground. -----------------!
   agf_bs(1:18)   = 0.7                                                                                     ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Fraction of above-ground wood that is assumed to be in branches and twigs.  Here  !
   ! we must be careful to make sure that the fraction is 0 in case WAI is going to be     !
   ! zero (e.g. grasses).                                                                  !
   !---------------------------------------------------------------------------------------!
   where (b1WAI(:) == 0.0)
      !----- WAI is going to be zero, so branch biomass should be zero as well. -----------!
      brf_wd(:) = 0.0
      !------------------------------------------------------------------------------------!
   elsewhere
      !------------------------------------------------------------------------------------!
      !     This may go outside the where loop eventually, for the time being assume the   !
      ! same for all tree PFTs.                                                            !
      !------------------------------------------------------------------------------------!
      brf_wd(:) = 0.16
      !------------------------------------------------------------------------------------!
   end where
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     DBH-Root depth allometry.  Check which allometry to use.  Notice that b?Rd have   !
   ! different meanings depending on the allometry. b?Vol is always defined because we     !
   ! may want to estimate the standing volume for other reasons (e.g. the characteristic   !
   ! diameter of branches).                                                                !
   !---------------------------------------------------------------------------------------!
   b1Vol(1:17)  = 0.65 * pi1 * 0.11 * 0.11
   b1Vol(18)    = 0.00002035                                                                                ! CHANGED
   b2Vol(1:17)  = 2.0
   b2Vol(18)    = 2.314                                                                                     ! CHANGED

   select case (iallom)                                                                                                                                       
   case (0)
      b1Rd(1)     = - 0.700
      b1Rd(2:4)   = - exp(0.545 * log(10.))
      b1Rd(5)     = - 0.700
      b1Rd(6:11)  = - exp(0.545 * log(10.))
      b1Rd(12:16) = - 0.700
      b1Rd(17)    = - exp(0.545 * log(10.))
      b1Rd(18)    = - 3.000                                                                                ! CHANGED

      b2Rd(1)     = 0.000
      b2Rd(2:4)   = 0.277
      b2Rd(5)     = 0.000
      b2Rd(6:11)  = 0.277
      b2Rd(12:16) = 0.000
      b2Rd(17)    = 0.277
      b2RD(18)    = 0.150                                                                                  ! CHANGED
   case default
      !------------------------------------------------------------------------------------!
      !     This is just a test, not based on any paper.  This is simply a fit that would  !
      ! put the roots 0.5m deep for plants 0.15m-tall and 5 m for plants 35-m tall.        !
      !------------------------------------------------------------------------------------!
      b1Rd(1:17)  = -1.1140580
      b2Rd(1:17)  =  0.4223014
      !------------------------------------------------------------------------------------!
      !     This is just a test for Great Basin shrubs which have very long tap roots that !
      ! can reach deep depths early.                                                       !
      !------------------------------------------------------------------------------------!
      b1Rd(18)    = -1.75                                                                                   ! CHANGED
      b2Rd(18)    =  0.10                                                                                   ! CHANGED
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Initial density of plants, for near-bare-ground simulations [# of individuals/m2]  !
   !---------------------------------------------------------------------------------------!
   select case (ibigleaf)
   case (0)
      !----- Size and age structure. ------------------------------------------------------!
      select case (iallom)
      case (0,1)
         init_density(1)     = 1.0
         init_density(2:4)   = 1.0
         init_density(5)     = 0.1
         init_density(6:8)   = 0.1
         init_density(9:11)  = 0.1
         init_density(12:13) = 0.1
         init_density(14:15) = 0.1
         init_density(16)    = 1.0
         init_density(17)    = 1.0
         init_density(18)    = 0.1                                                                          ! CHANGED
      case default
         init_density(1)     = 0.1
         init_density(2:4)   = 0.1
         init_density(5)     = 0.1
         init_density(6:8)   = 0.1
         init_density(9:11)  = 0.1
         init_density(12:13) = 0.1
         init_density(14:15) = 0.1
         init_density(16)    = 0.1
         init_density(17)    = 0.1
         init_density(18)    = 0.1                                                                          ! CHANGED
      end select

      !----- Define a non-sense number. ---------------------------------------------------!
      init_laimax(1:18)   = huge_num                                                                        ! CHANGED

   case(1)
      !----- Big leaf. 1st we set the maximum initial LAI for each PFT. -------------------!
      init_laimax(1:18)   = 0.1                                                                             ! CHANGED
      do ipft=1,n_pft
         init_bleaf = size2bl(dbh_bigleaf(ipft),hgt_max(ipft),ipft)
         init_density(ipft) = init_laimax(ipft) / (init_bleaf * SLA(ipft))
      end do
      !------------------------------------------------------------------------------------!
   end select
   !---------------------------------------------------------------------------------------!


   if (write_allom) then
      open (unit=18,file=trim(allom_file),status='replace',action='write')
      write(unit=18,fmt='(312a)') ('-',n=1,312)
      write(unit=18,fmt='(28(1x,a))') '         PFT','    Tropical','       Grass'         &
                                     ,'         Rho','        b1Ht','        b2Ht'         &
                                     ,'     Hgt_ref','  b1Bl_small','  b2Bl_small'         &
                                     ,'  b1Bl_large','  b2Bl_large','  b1Bs_Small'         &
                                     ,'  b2Bs_Small','  b1Bs_Large','  b1Bs_Large'         &
                                     ,'        b1Ca','        b2Ca','     Hgt_min'         &
                                     ,'     Hgt_max','     Min_DBH','   DBH_Adult'         &
                                     ,'    DBH_Crit',' DBH_BigLeaf',' Bleaf_Adult'         &
                                     ,'  Bdead_Crit','   Init_dens',' Init_LAImax'         &
                                     ,'         SLA'

      write(unit=18,fmt='(312a)') ('-',n=1,312)
      do ipft=1,n_pft
         write (unit=18,fmt='(8x,i5,2(12x,l1),25(1x,es12.5))')                             &
                        ipft,is_tropical(ipft),is_grass(ipft),rho(ipft),b1Ht(ipft)         &
                       ,b2Ht(ipft),hgt_ref(ipft),b1Bl_small(ipft),b2Bl_small(ipft)         &
                       ,b1Bl_large(ipft),b2Bl_large(ipft),b1Bs_small(ipft)                 &
                       ,b2Bs_small(ipft),b1Bs_large(ipft),b2Bs_large(ipft),b1Ca(ipft)      &
                       ,b2Ca(ipft),hgt_min(ipft),hgt_max(ipft),min_dbh(ipft)               &
                       ,dbh_adult(ipft),dbh_crit(ipft),dbh_bigleaf(ipft)                   &
                       ,bleaf_adult(ipft),bdead_crit(ipft),init_density(ipft)              &
                       ,init_laimax(ipft),sla(ipft)
      end do
      write(unit=18,fmt='(312a)') ('-',n=1,312)
      close(unit=18,status='keep')
   end if

   return
end subroutine init_pft_alloc_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_pft_nitro_params()

use pft_coms, only: c2n_leaf, Vm0, SLA, &
     c2n_slow,c2n_structural,c2n_storage,c2n_stem,l2n_stem, &
     C2B,plant_N_supply_scale

implicit none

c2n_slow       = 10.0  ! Carbon to Nitrogen ratio, slow pool.
c2n_structural = 150.0 ! Carbon to Nitrogen ratio, structural pool.
c2n_storage    = 150.0 ! Carbon to Nitrogen ratio, storage pool.
c2n_stem       = 150.0 ! Carbon to Nitrogen ratio, structural stem.
l2n_stem       = 150.0 ! Carbon to Nitrogen ratio, structural stem.


plant_N_supply_scale = 0.5 

c2n_leaf(1:5)    = 1000.0 / ((0.11289 + 0.12947 *   Vm0(1:5)) * SLA(1:5)  )
c2n_leaf(6)      = 1000.0 / ((0.11289 + 0.12947 *     15.625) * SLA(6)    )
c2n_leaf(7)      = 1000.0 / ((0.11289 + 0.12947 *     15.625) * SLA(7)    )
c2n_leaf(8)      = 1000.0 / ((0.11289 + 0.12947 *       6.25) * SLA(8)    )
c2n_leaf(9)      = 1000.0 / ((0.11289 + 0.12947 *      18.25) * SLA(9)    )
c2n_leaf(10)     = 1000.0 / ((0.11289 + 0.12947 *     15.625) * SLA(10)   )
c2n_leaf(11)     = 1000.0 / ((0.11289 + 0.12947 *       6.25) * SLA(11)   )
c2n_leaf(12:15)  = 1000.0 / ((0.11289 + 0.12947 * Vm0(12:15)) * SLA(12:15))
c2n_leaf(16:17)  = 1000.0 / ((0.11289 + 0.12947 * Vm0(16:17)) * SLA(16:17))
c2n_leaf(18)     = 1000.0 / ((0.11289 + 0.12947 *    Vm0(18)) * SLA(18)   )                                    ! CHANGED



return
end subroutine init_pft_nitro_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!   This subroutine sets up some PFT and leaf dependent properties.                        !
!------------------------------------------------------------------------------------------!
subroutine init_pft_leaf_params()
   use phenology_coms , only : iphen_scheme         ! ! intent(in)
   use ed_misc_coms   , only : igrass               ! ! intent(in)
   use rk4_coms       , only : ibranch_thermo       ! ! intent(in)
   use pft_coms       , only : phenology            & ! intent(out)
                             , b1Cl                 & ! intent(out)
                             , b2Cl                 & ! intent(out)
                             , c_grn_leaf_dry       & ! intent(out)
                             , c_ngrn_biom_dry      & ! intent(out)
                             , wat_dry_ratio_grn    & ! intent(out)
                             , wat_dry_ratio_ngrn   & ! intent(out)
                             , delta_c              ! ! intent(out)
   use consts_coms    , only : t00                  ! ! intent(out)

   implicit none

   !----- Reference temperature for heat capacity. ----------------------------------------!
   real, parameter :: tref = t00 + 15.
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Tree phenology is the same for both cases, but in the new grass allometry they    !
   ! must be evergreens.                                                                   !
   !---------------------------------------------------------------------------------------!
   select case (igrass)
   case (0)
      !----- Bonsai grasses. --------------------------------------------------------------!
      select case (iphen_scheme)
      case (-1)
         phenology(1:8)   = 0
         phenology(9:11)  = 2
         phenology(12:18) = 0                                                                                  ! CHANGED
      case (0,1)
         phenology(1)     = 1
         phenology(2:4)   = 1
         phenology(5)     = 1
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 1
         phenology(16)    = 1
         phenology(17:18) = 0                                                                                  ! CHANGED
      case (2)
         phenology(1)     = 4
         phenology(2:4)   = 4
         phenology(5)     = 4
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 4
         phenology(16)    = 4
         phenology(17:18) = 0                                                                                  ! CHANGED
      case (3)
         phenology(1)     = 4
         phenology(2:4)   = 3
         phenology(5)     = 4
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 4
         phenology(16)    = 4
         phenology(17:18) = 0                                                                                  ! CHANGED
      end select
      !------------------------------------------------------------------------------------!
   case (1)
      !----- New grasses. -----------------------------------------------------------------!
      select case (iphen_scheme)
      case (-1)
         phenology(1:8)   = 0
         phenology(9:11)  = 2
         phenology(12:18) = 0                                                                                  ! CHANGED
      case (0,1)
         phenology(1)     = 0
         phenology(2:4)   = 1
         phenology(5)     = 0
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 1
         phenology(16)    = 0
         phenology(17:18) = 0                                                                                  ! CHANGED
      case (2)
         phenology(1)     = 0
         phenology(2:4)   = 4
         phenology(5)     = 0
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 0
         phenology(16)    = 0
         phenology(17:18) = 0                                                                                  ! CHANGED
      case (3)
         phenology(1)     = 0
         phenology(2:4)   = 3
         phenology(5)     = 0
         phenology(6:8)   = 0
         phenology(9:11)  = 2
         phenology(12:15) = 0
         phenology(16)    = 0
         phenology(17:18) = 0                                                                                  ! CHANGED
      end select
      !------------------------------------------------------------------------------------!
   end select
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      The following parameters are second sources found in Gu et al. (2007)            !
   !---------------------------------------------------------------------------------------!
   c_grn_leaf_dry     (1:18) = 3218.0    ! Jones 1992  J/(kg K)                                                ! CHANGED
   wat_dry_ratio_ngrn (1:18) = 0.7       ! Forest Products Laboratory (2010)                                   ! CHANGED
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !      Water dry ratio for leaves.  Source depends on whether the plants are tropical   !
   ! or temperate.                                                                         !
   ! Tropical  -- average well-watered values of wd from:                                  !
   !              Kursar et al., 2009: Functional Ecology, 23, 93-102.                     !
   ! Temperate -- check with MCD.  Original value was 1.5, from Gu et. al (2007) but it    !
   !              has been replaced by 2.5.  Perhaps to account for the C:B ratio, but if  !
   !              this is the case, it is accounting for it twice.                         !
   !---------------------------------------------------------------------------------------!
   wat_dry_ratio_grn(  1:4) = 1.85
   wat_dry_ratio_grn( 5:13) = 2.50
   wat_dry_ratio_grn(14:17) = 1.85
   wat_dry_ratio_grn(   18) = 2.50                                                                             ! CHANGED
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    The oven-dry wood heat capacity and the specific heat correction for water-wood    !
   ! bonding come both from:                                                               !
   ! Forest Products Laboratory (2010), previous version cited by Gu et al. (2007).        !
   !                                                                                       !
   !    Instead of using the temperature-dependence, we use the values at 15C, and assume  !
   ! that the values are constant.                                                         !
   ! CHANGED-KP                                                                            !
   !---------------------------------------------------------------------------------------!
   c_ngrn_biom_dry(1:18) = 103.1 + 3.867 * tref
   delta_c        (1:18) = 1.e5 * wat_dry_ratio_ngrn(1:18)                                 &
                         * ( - 0.06191 + 2.36e-4 * tref                                    &
                                       - 1.33e-2 * wat_dry_ratio_ngrn(1:18) )
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     These are used to compute the crown length, which will then be used to find the   !
   ! height of the bottom of the crown.  This allometry is based on:                       !
   !                                                                                       !
   ! Poorter L., L. Bongers, F. Bongers, 2006: Architecture of 54 moist-forest tree        !
   !     species: traits, trade-offs, and functional groups. Ecology, 87, 1289-1301.       !
   !---------------------------------------------------------------------------------------!
   !----- Intercept. ----------------------------------------------------------------------!
   b1Cl(1)     = 0.99
   b1Cl(2:4)   = 0.3106775
   b1Cl(5)     = 0.99
   b1Cl(6:11)  = 0.3106775
   b1Cl(12:16) = 0.99
   b1Cl(17)    = 0.3106775
   b1Cl(18)    = 1.0                                                                                        ! CHANGED
   !----- Slope. ----------------------------------------------------------------------!
   b2Cl(1)     = 1.0
   b2Cl(2:4)   = 1.098
   b2Cl(5)     = 1.0
   b2Cl(6:11)  = 1.098
   b2Cl(12:16) = 1.0
   b2Cl(17)    = 1.098
   b2Cl(18)    = 1.0                                                                                        ! CHANGED
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_pft_leaf_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine sets some reproduction-related parameters.                            !
!------------------------------------------------------------------------------------------!
subroutine init_pft_repro_params()

   use pft_coms, only : r_fract            & ! intent(out)
                      , st_fract           & ! intent(out)
                      , nonlocal_dispersal & ! intent(out)
                      , repro_min_h        ! ! intent(out)
   implicit none

   r_fract(1)              = 0.3
   r_fract(2:4)            = 0.3
   r_fract(5)              = 0.3
   r_fract(6:11)           = 0.3
   r_fract(12:15)          = 0.3
   r_fract(16)             = 0.3
   r_fract(17)             = 0.3
   r_fract(18)             = 0.3                                                                            ! CHANGED

   st_fract(1)             = 0.0
   st_fract(2:4)           = 0.0
   st_fract(5)             = 0.0
   st_fract(6:11)          = 0.0
   st_fract(12:15)         = 0.0
   st_fract(16)            = 0.0
   st_fract(17)            = 0.0
   st_fract(18)            = 0.0                                                                            ! CHANGED

   nonlocal_dispersal(1)   =  1.000 ! 1.000
   nonlocal_dispersal(2)   =  1.000 ! 0.900
   nonlocal_dispersal(3)   =  1.000 ! 0.550
   nonlocal_dispersal(4)   =  1.000 ! 0.200
   nonlocal_dispersal(5)   =  1.000 ! 1.000
   nonlocal_dispersal(6)   =  0.766 ! 0.766
   nonlocal_dispersal(7)   =  0.766 ! 0.766
   nonlocal_dispersal(8)   =  0.001 ! 0.001
   nonlocal_dispersal(9)   =  1.000 ! 1.000
   nonlocal_dispersal(10)  =  0.325 ! 0.325
   nonlocal_dispersal(11)  =  0.074 ! 0.074
   nonlocal_dispersal(12)  =  1.000 ! 1.000
   nonlocal_dispersal(13)  =  1.000 ! 1.000
   nonlocal_dispersal(14)  =  1.000 ! 1.000
   nonlocal_dispersal(15)  =  1.000 ! 1.000
   nonlocal_dispersal(16)  =  1.000 ! 1.000
   nonlocal_dispersal(17)  =  0.766 ! 0.600
   nonlocal_dispersal(18)  =  0.325                                                                         ! CHANGED - start with this value

   repro_min_h(1)          =  0.0
   repro_min_h(2:4)        = 18.0
   repro_min_h(5)          =  0.0
   repro_min_h(6:11)       = 18.0
   repro_min_h(12:15)      =  0.0
   repro_min_h(16)         =  0.0
   repro_min_h(17)         = 18.0
   repro_min_h(18)         = 0.25                                                                           ! CHANGED

   return
end subroutine init_pft_repro_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine will assign some variables that depend on the definition of other     !
! PFT parameters.  As such, this should be the last init_pft subroutine to be called.      !
!------------------------------------------------------------------------------------------!
subroutine init_pft_derived_params()
   use decomp_coms          , only : f_labile             ! ! intent(in)
   use detailed_coms        , only : idetailed            ! ! intent(in)
   use ed_misc_coms         , only : ibigleaf             ! ! intent(in)
   use ed_max_dims          , only : n_pft                & ! intent(in)
                                   , str_len              ! ! intent(in)
   use consts_coms          , only : onesixth             & ! intent(in)
                                   , twothirds            ! ! intent(in)
   use pft_coms             , only : init_density         & ! intent(in)
                                   , c2n_leaf             & ! intent(in)
                                   , c2n_stem             & ! intent(in)
                                   , b1Ht                 & ! intent(in)
                                   , b2Ht                 & ! intent(in)
                                   , hgt_min              & ! intent(in)
                                   , hgt_ref              & ! intent(in)
                                   , q                    & ! intent(in)
                                   , qsw                  & ! intent(in)
                                   , sla                  & ! intent(in)
                                   , pft_name16           & ! intent(in)
                                   , hgt_max              & ! intent(in)
                                   , dbh_crit             & ! intent(in)
                                   , dbh_bigleaf          & ! intent(in)
                                   , one_plant_c          & ! intent(out)
                                   , min_recruit_size     & ! intent(out)
                                   , min_cohort_size      & ! intent(out)
                                   , negligible_nplant    & ! intent(out)
                                   , c2n_recruit          & ! intent(out)
                                   , veg_hcap_min         & ! intent(out)
                                   , seed_rain            ! ! intent(out)
   use phenology_coms       , only : elongf_min           & ! intent(in)
                                   , elongf_flush         ! ! intent(in)
   use allometry            , only : h2dbh                & ! function
                                   , dbh2h                & ! function
                                   , size2bl              & ! function
                                   , dbh2bd               ! ! function
   use ed_therm_lib         , only : calc_veg_hcap        ! ! function
   implicit none
   !----- Local variables. ----------------------------------------------------------------!
   integer                           :: ipft
   real                              :: dbh
   real                              :: huge_dbh
   real                              :: huge_height
   real                              :: bleaf_min
   real                              :: broot_min
   real                              :: bsapwood_min
   real                              :: balive_min
   real                              :: bdead_min
   real                              :: bleaf_max
   real                              :: broot_max
   real                              :: bsapwood_max
   real                              :: balive_max
   real                              :: bdead_max
   real                              :: bleaf_bl
   real                              :: broot_bl
   real                              :: bsapwood_bl
   real                              :: balive_bl
   real                              :: bdead_bl
   real                              :: leaf_hcap_min
   real                              :: wood_hcap_min
   real                              :: lai_min
   real                              :: min_plant_dens
   logical                           :: print_zero_table
   character(len=str_len), parameter :: zero_table_fn    = 'pft_sizes.txt'
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !     Decide whether to write the table with the sizes.                                 !
   !---------------------------------------------------------------------------------------!
   print_zero_table = btest(idetailed,5)
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !     The minimum recruitment size and the recruit carbon to nitrogen ratio.  Both      !
   ! parameters actually depend on which PFT we are solving, since grasses always have     !
   ! significantly less biomass.                                                           !
   !---------------------------------------------------------------------------------------!
   if (print_zero_table) then
      open  (unit=61,file=trim(zero_table_fn),status='replace',action='write')
      write (unit=61,fmt='(29(a,1x))')                '  PFT',        'NAME            '   &
                                              ,'     HGT_MIN','         DBH'               &
                                              ,'   BLEAF_MIN','   BROOT_MIN'               &
                                              ,'BSAPWOOD_MIN','  BALIVE_MIN'               &
                                              ,'   BDEAD_MIN','    BLEAF_BL'               &
                                              ,'    BROOT_BL',' BSAPWOOD_BL'               &
                                              ,'   BALIVE_BL','    BDEAD_BL'               &
                                              ,'   BLEAF_MAX','   BROOT_MAX'               &
                                              ,'BSAPWOOD_MAX','  BALIVE_MAX'               &
                                              ,'   BDEAD_MAX','   INIT_DENS'               &
                                              ,'MIN_REC_SIZE','MIN_COH_SIZE'               &
                                              ,' NEGL_NPLANT','         SLA'               &
                                              ,'VEG_HCAP_MIN','     LAI_MIN'               &
                                              ,'     HGT_MAX','    DBH_CRIT'               &
                                              ,' ONE_PLANT_C'
   end if
   min_plant_dens = 0.1 * minval(init_density)
   do ipft = 1,n_pft

      !----- Find the DBH and carbon pools associated with a newly formed recruit. --------!
      dbh          = h2dbh(hgt_min(ipft),ipft)
      bleaf_min    = size2bl(dbh,hgt_min(ipft),ipft) 
      broot_min    = bleaf_min * q(ipft)
      bsapwood_min = bleaf_min * qsw(ipft) * hgt_min(ipft)
      balive_min   = bleaf_min + broot_min + bsapwood_min
      bdead_min    = dbh2bd(dbh,ipft)
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !   Find the maximum bleaf and bdead supported.  This is to find the negligible      !
      ! nplant so we ensure that the cohort is always terminated if its mortality rate is  !
      ! very high.                                                                         !
      !------------------------------------------------------------------------------------!
      huge_dbh     = 3. * dbh_crit(ipft)
      huge_height  = dbh2h(ipft, dbh_crit(ipft))
      bleaf_max    = size2bl(huge_dbh,huge_height,ipft)
      broot_max    = bleaf_max * q(ipft)
      bsapwood_max = bleaf_max * qsw(ipft) * huge_height
      balive_max   = bleaf_max + broot_max + bsapwood_max
      bdead_max    = dbh2bd(huge_dbh,ipft)
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !    Biomass of one individual plant at recruitment.                                 !
      !------------------------------------------------------------------------------------!
      bleaf_bl          = size2bl(dbh_bigleaf(ipft),hgt_min(ipft),ipft) 
      broot_bl          = bleaf_bl * q(ipft)
      bsapwood_bl       = bleaf_bl * qsw(ipft) * hgt_max(ipft)
      balive_bl         = bleaf_bl + broot_bl + bsapwood_bl
      bdead_bl          = dbh2bd(dbh_bigleaf(ipft),ipft)
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !     Find the carbon value for one plant.  If SAS approximation, we define it as    !
      ! the carbon of a seedling, and for the big leaf case we assume the typical big leaf !
      ! plant size.                                                                        !
      !------------------------------------------------------------------------------------!
      select case (ibigleaf)
      case (0)
         one_plant_c(ipft) = bdead_min + balive_min
      case (1)
         one_plant_c(ipft) = bdead_bl  + balive_bl
      end select
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !    The definition of the minimum recruitment size is the minimum amount of biomass !
      ! in kgC/m� is available for new recruits.  For the time being we use the near-bare  !
      ! ground state value as the minimum recruitment size, but this may change depending  !
      ! on how well it goes.                                                               !
      !------------------------------------------------------------------------------------!
      min_recruit_size(ipft) = min_plant_dens * one_plant_c(ipft)
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !    Minimum size (measured as biomass of living and structural tissues) allowed in  !
      ! a cohort.  Cohorts with less biomass than this are going to be terminated.         !
      !------------------------------------------------------------------------------------! 
      min_cohort_size(ipft)  = 0.1 * min_recruit_size(ipft)
      !------------------------------------------------------------------------------------! 


      !------------------------------------------------------------------------------------!
      !    Seed_rain is the density of seedling that will be added from somewhere else.    !
      !------------------------------------------------------------------------------------! 
      seed_rain(ipft)  = 0.1 * init_density(ipft)
      !------------------------------------------------------------------------------------! 



      !------------------------------------------------------------------------------------! 
      !    The following variable is the absolute minimum cohort population that a cohort  !
      ! can have.  This should be used only to avoid nplant=0, but IMPORTANT: this will    !
      ! lead to a ridiculously small cohort almost guaranteed to be extinct and SHOULD BE  !
      ! USED ONLY IF THE AIM IS TO ELIMINATE THE COHORT.                                   !
      !------------------------------------------------------------------------------------! 
      negligible_nplant(ipft) = onesixth * min_cohort_size(ipft) / (bdead_max + balive_max)
      !------------------------------------------------------------------------------------! 


      !----- Find the recruit carbon to nitrogen ratio. -----------------------------------!
      c2n_recruit(ipft)      = (balive_min + bdead_min)                                    &
                             / (balive_min * ( f_labile(ipft) / c2n_leaf(ipft)             &
                             + (1.0 - f_labile(ipft)) / c2n_stem(ipft))                    &
                             + bdead_min/c2n_stem(ipft))
      !------------------------------------------------------------------------------------! 



      !------------------------------------------------------------------------------------!
      !     The following variable is the minimum heat capacity of either the leaf, or the !
      ! branches, or the combined pool that is solved by the biophysics.  Value is in      !
      ! J/m2/K.  Because leaves are the pools that can determine the fate of the tree, and !
      ! all PFTs have leaves (but not branches), we only consider the leaf heat capacity   !
      ! only for the minimum value.                                                        !
      !------------------------------------------------------------------------------------!
      call calc_veg_hcap(bleaf_min,bdead_min,bsapwood_min,init_density(ipft),ipft          &
                        ,leaf_hcap_min,wood_hcap_min)
      veg_hcap_min(ipft) = onesixth * leaf_hcap_min
      lai_min            = onesixth * init_density(ipft) * bleaf_min * sla(ipft)
      !------------------------------------------------------------------------------------!


      if (print_zero_table) then
         write (unit=61,fmt='(i5,1x,a16,1x,27(es12.5,1x))')                                &
                                                     ipft,pft_name16(ipft),hgt_min(ipft)   &
                                                    ,dbh,bleaf_min,broot_min,bsapwood_min  &
                                                    ,balive_min,bdead_min,bleaf_bl         &
                                                    ,broot_bl,bsapwood_bl,balive_bl        &
                                                    ,bdead_bl,bleaf_max,broot_max          &
                                                    ,bsapwood_max,balive_max,bdead_max     &
                                                    ,init_density(ipft)                    &
                                                    ,min_recruit_size(ipft)                &
                                                    ,min_cohort_size(ipft)                 &
                                                    ,negligible_nplant(ipft)               &
                                                    ,sla(ipft),veg_hcap_min(ipft)          &
                                                    ,lai_min,hgt_max(ipft),dbh_crit(ipft)  &
                                                    ,one_plant_c(ipft)
      end if
      !------------------------------------------------------------------------------------!
   end do

   if (print_zero_table) then
      close (unit=61,status='keep')
   end if

   return
end subroutine init_pft_derived_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_disturb_params

   use disturb_coms , only : treefall_hite_threshold  & ! intent(out)
                           , fire_hite_threshold      & ! intent(out)
                           , forestry_on              & ! intent(out)
                           , agriculture_on           & ! intent(out)
                           , plantation_year          & ! intent(out)
                           , plantation_rotation      & ! intent(out)
                           , min_harvest_biomass      & ! intent(out)
                           , mature_harvest_age       & ! intent(out)
                           , fire_dryness_threshold   & ! intent(out)
                           , fire_smoist_depth        & ! intent(out)
                           , k_fire_first             & ! intent(out)
                           , min_plantation_frac      & ! intent(out)
                           , max_plantation_dist      ! ! intent(out)
   use consts_coms  , only : erad                     & ! intent(in)
                           , pio180                   ! ! intent(in)
   use soil_coms    , only : slz                      ! ! intent(in)
   use grid_coms    , only : nzg                      ! ! intent(in)
   implicit none

   !----- Only trees above this height create a gap when they fall. -----------------------!
   treefall_hite_threshold = 10.0 

   !----- Cut-off for fire survivorship (bush fires versus canopy fire). ------------------!
   fire_hite_threshold     = 5.0

   !----- Set to 1 if to do forest harvesting. --------------------------------------------!
   forestry_on = 0

   !----- Set to 1 if to do agriculture. --------------------------------------------------!
   agriculture_on = 0

   !----- Earliest year at which plantations occur. ---------------------------------------!
   plantation_year = 1960 

   !----- Number of years that a plantation requires to reach maturity. -------------------!
   plantation_rotation = 25.0

   !----- Minimum site biomass, below which harvest is skipped. ---------------------------!
   min_harvest_biomass = 0.001

   !----- Years that a non-plantation patch requires to reach maturity. -------------------!
   mature_harvest_age = 50.0 
   
   !---------------------------------------------------------------------------------------!
   !     If include_fire is 1, then fire may occur if total (ground + underground) water   !
   ! converted to meters falls below this threshold.                                       !
   !---------------------------------------------------------------------------------------!
   fire_dryness_threshold = 0.2
   !---------------------------------------------------------------------------------------!

   !----- Maximum depth that will be considered in the average soil -----------------------!
   fire_smoist_depth     = -0.2
   !---------------------------------------------------------------------------------------!

   !----- Determine the top layer to consider for fires in case include_fire is 2 or 3. ---!
   kfireloop: do k_fire_first=nzg-1,1,-1
     if (slz(k_fire_first) < fire_smoist_depth) exit kfireloop
   end do kfireloop
   k_fire_first = k_fire_first + 1
   !---------------------------------------------------------------------------------------!



   !----- Minimum plantation fraction to consider the site a plantation. ------------------!
   min_plantation_frac = 0.125

   !---------------------------------------------------------------------------------------!
   !    Maximum distance to the current polygon that we still consider the file grid point !
   ! to be representative of the polygon.  The value below is 1.25 degree at the Equator.  !
   !---------------------------------------------------------------------------------------!
   max_plantation_dist = 1.25 * erad * pio180
   !---------------------------------------------------------------------------------------!

   return

end subroutine init_disturb_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine initialises various PFT-independent variables for the leaf physiology !
! model.  Some useful references for this sub-routine:                                     !
!                                                                                          !
! - M09 - Medvigy, D.M., S. C. Wofsy, J. W. Munger, D. Y. Hollinger, P. R. Moorcroft,      !
!         2009: Mechanistic scaling of ecosystem function and dynamics in space and time:  !
!         Ecosystem Demography model version 2.  J. Geophys. Res., 114, G01002,            !
!         doi:10.1029/2008JG000812.                                                        !
! - M06 - Medvigy, D.M., 2006: The State of the Regional Carbon Cycle: results from a      !
!         constrained coupled ecosystem-atmosphere model, 2006.  Ph.D. dissertation,       !
!         Harvard University, Cambridge, MA, 322pp.                                        !
! - M01 - Moorcroft, P. R., G. C. Hurtt, S. W. Pacala, 2001: A method for scaling          !
!         vegetation dynamics: the ecosystem demography model, Ecological Monographs, 71,  !
!         557-586.                                                                         !
! - F96 - Foley, J. A., I. Colin Prentice, N. Ramankutty, S. Levis, D. Pollard, S. Sitch,  !
!         A. Haxeltime, 1996: An integrated biosphere model of land surface processes,     !
!         terrestrial carbon balance, and vegetation dynamics. Glob. Biogeochem. Cycles,   !
!         10, 603-602.                                                                     !
! - L95 - Leuning, R., F. M. Kelliher, D. G. G. de Pury, E. D. Schulze, 1995: Leaf         !
!         nitrogen, photosynthesis, conductance, and transpiration: scaling from leaves to !
!         canopies. Plant, Cell, and Environ., 18, 1183-1200.                              !
! - F80 - Farquhar, G. D., S. von Caemmerer, J. A. Berry, 1980: A biochemical model of     !
!         photosynthetic  CO2 assimilation in leaves of C3 species. Planta, 149, 78-90.    !
! - C91 - Collatz, G. J., J. T. Ball, C. Grivet, J. A. Berry, 1991: Physiology and         !
!         environmental regulation of stomatal conductance, photosynthesis and transpir-   !
!         ation: a model that includes a laminar boundary layer, Agric. and Forest         !
!         Meteorol., 54, 107-136.                                                          !
! - C92 - Collatz, G. J., M. Ribas-Carbo, J. A. Berry, 1992: Coupled photosynthesis-       !
!         stomatal conductance model for leaves of C4 plants.  Aust. J. Plant Physiol.,    !
!         19, 519-538.                                                                     !
! - E78 - Ehleringer, J. R., 1978: Implications of quantum yield differences on the        !
!         distributions of C3 and C4 grasses.  Oecologia, 31, 255-267.                     !
!                                                                                          !
!------------------------------------------------------------------------------------------!
subroutine init_physiology_params()
   use detailed_coms  , only : idetailed           ! ! intent(in)
   use ed_misc_coms, only    : ffilout
   use physiology_coms, only : iphysiol            & ! intent(in)
                             , klowco2in           & ! intent(in)
                             , c34smin_lint_co2    & ! intent(out)
                             , c34smax_lint_co2    & ! intent(out)
                             , c34smax_gsw         & ! intent(out)
                             , gbh_2_gbw           & ! intent(out)
                             , gbw_2_gbc           & ! intent(out)
                             , gsw_2_gsc           & ! intent(out)
                             , gsc_2_gsw           & ! intent(out)
                             , kookc               & ! intent(out)
                             , tphysref            & ! intent(out)
                             , tphysrefi           & ! intent(out)
                             , fcoll               & ! intent(out)
                             , compp_refval        & ! intent(out)
                             , compp_hor           & ! intent(out)
                             , compp_q10           & ! intent(out)
                             , kco2_refval         & ! intent(out)
                             , kco2_hor            & ! intent(out)
                             , kco2_q10            & ! intent(out)
                             , ko2_refval          & ! intent(out)
                             , ko2_hor             & ! intent(out)
                             , ko2_q10             & ! intent(out)
                             , klowco2             & ! intent(out)
                             , o2_ref              & ! intent(out)
                             , par_twilight_min    & ! intent(out)
                             , qyield0             & ! intent(out)
                             , qyield1             & ! intent(out)
                             , qyield2             & ! intent(out)
                             , ehleringer_alpha0c  & ! intent(out)
                             , c34smin_lint_co28   & ! intent(out)
                             , c34smax_lint_co28   & ! intent(out)
                             , c34smax_gsw8        & ! intent(out)
                             , gbh_2_gbw8          & ! intent(out)
                             , gbw_2_gbc8          & ! intent(out)
                             , gsw_2_gsc8          & ! intent(out)
                             , gsc_2_gsw8          & ! intent(out)
                             , kookc8              & ! intent(out)
                             , tphysref8           & ! intent(out)
                             , tphysrefi8          & ! intent(out)
                             , fcoll8              & ! intent(out)
                             , compp_refval8       & ! intent(out)
                             , compp_hor8          & ! intent(out)
                             , compp_q108          & ! intent(out)
                             , kco2_refval8        & ! intent(out)
                             , kco2_hor8           & ! intent(out)
                             , kco2_q108           & ! intent(out)
                             , ko2_refval8         & ! intent(out)
                             , ko2_hor8            & ! intent(out)
                             , ko2_q108            & ! intent(out)
                             , klowco28            & ! intent(out)
                             , par_twilight_min8   & ! intent(out)
                             , o2_ref8             & ! intent(out)
                             , qyield08            & ! intent(out)
                             , qyield18            & ! intent(out)
                             , qyield28            & ! intent(out)
                             , ehleringer_alpha0c8 & ! intent(out)
                             , print_photo_debug   & ! intent(out)
                             , photo_prefix        ! ! intent(out)
   use consts_coms    , only : umol_2_mol          & ! intent(in)
                             , t00                 & ! intent(in)
                             , mmdoc               & ! intent(in)
                             , mmcod               & ! intent(in)
                             , mmo2                & ! intent(in)
                             , mmdryi              & ! intent(in)
                             , Watts_2_Ein         & ! intent(in)
                             , prefsea             ! ! intent(in)
   implicit none
   !------ Local constants. ---------------------------------------------------------------!
   real, parameter :: ehl0           =  8.10e-2 ! Intercept                    (E78, eqn 2)
   real, parameter :: ehl1           = -5.30e-5 ! Linear coefficient           (E78, eqn 2)
   real, parameter :: ehl2           = -1.90e-5 ! Quadratic coefficient        (E78, eqn 2)
   real, parameter :: tau_refval_f96 =  4500.   ! Reference tau                (F96)
   real, parameter :: tau_refval_c91 =  2600.   ! Reference tau                (C91)
   real, parameter :: tau_hor        = -5000.   ! "Activation energy" for tau  (F96)
   real, parameter :: tau_q10        =  0.57    ! "Q10" term for tau           (C91)  
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Bounds for internal carbon and water stomatal conductance.                        !
   !---------------------------------------------------------------------------------------!
   c34smin_lint_co2 = 0.5   * umol_2_mol ! Minimum carbon dioxide concentration [  mol/mol]
   c34smax_lint_co2 = 1200. * umol_2_mol ! Maximum carbon dioxide concentration [  mol/mol]
   c34smax_gsw      = 1.e+2              ! Max. stomatal conductance (water)    [ mol/m�/s]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Many parameters in the model are temperature-dependent and we must provide a      !
   ! reference value and shape parameters.  Here we define this reference temperature.     !
   ! IMPORTANT: Some schemes use 15 C (F96-based in particular), whilst others use 25 C    !
   ! (C91-based in particular).  Be sure to make the necessary conversions of these        !
   ! references otherwise you may have surprises.                                          !
   !---------------------------------------------------------------------------------------!
   tphysref     = 15.0+t00
   tphysrefi    = 1./tphysref
   fcoll        = 0.10
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     The following parameter is the concentration of oxygen, assumed constant through- !
   ! out the integration.  The value is in mol/mol.                                        !
   !---------------------------------------------------------------------------------------!
   o2_ref       = 0.209
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     This parameter is from F80, and is the ratio between the turnover number for the  !
   ! oxylase function and the turnover number for the carboxylase function.                !
   !---------------------------------------------------------------------------------------!
   kookc        = 0.21
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Define the Michaelis-Mentel constants for CO2 and O2, and the CO2 compensation   !
   ! point without accounting leaf respiration (Gamma*).  Here we define the reference     !
   ! value and the compensation point parameters in a slightly different way depending on  !
   ! whether to use F96-based or C91-based physiology, and whether to use the              !
   ! pre-determined parameters or functions of the Michaelis-Mentel constant parameters.   !
   !---------------------------------------------------------------------------------------!
   !----- Common parameters. --------------------------------------------------------------!
   kco2_hor = 6000.  ! "Activation energy" for CO2 Michaelis-Mentel constant     [       K]
   kco2_q10 = 2.1    ! Q10 term for CO2 Michaelis-Mentel constant                [     ---]
   ko2_hor  = 1400.  ! "Activation energy" for O2 Michaelis-Mentel constants     [       K]
   ko2_q10  = 1.2    ! Q10 term for O2 Michaelis-Mentel constant                 [     ---]
   select case (iphysiol)
   case (0)
      !----- Use default CO2 and O2 reference values from F96. ----------------------------!
      kco2_refval   = 150. * umol_2_mol ! Reference Michaelis-Mentel CO2 coeff.  [ mol/mol]
      ko2_refval    = 0.250             ! Reference Michaelis-Mentel O2 coeff.   [ mol/mol]
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !   Use the default CO2 compensation point values from F96/M01, based on tau.        !
      !   Gamma* = [O2] / (2. * tau)                                                       !
      !------------------------------------------------------------------------------------!
      compp_refval  = o2_ref / (2. * tau_refval_f96) ! Reference value           [ mol/mol]
      compp_hor     = -tau_hor                       ! "Activation energy"       [       K]
      compp_q10     = 1. / tau_q10                   ! "Q10" term                [     ---]
      !------------------------------------------------------------------------------------!

   case (1)
      !----- Use default CO2 and O2 reference values from F96. ----------------------------!
      kco2_refval   = 150. * umol_2_mol ! Reference Michaelis-Mentel CO2 coeff.  [ mol/mol]
      ko2_refval    = 0.250             ! Reference Michaelis-Mentel O2 coeff.   [ mol/mol]
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !   Find the CO2 compensation point values using an approach similar to F80 and CLM. !
      !   Gamma* = (ko/kc) * [O2] * KCO2 / (2. * KO2)                                      !
      !------------------------------------------------------------------------------------!
      compp_refval  = kookc * o2_ref * kco2_refval / ko2_refval ! Ref. value     [ mol/mol]
      compp_hor     = kco2_hor - ko2_hor                        ! "Act. energy"  [       K]
      compp_q10     = kco2_q10 / ko2_q10                        ! "Q10" term     [     ---]
      !------------------------------------------------------------------------------------!

   case (2)
      !------------------------------------------------------------------------------------!
      !    Use default CO2 and O2 reference values from C91.  Here we must convert the     !
      ! reference values from Pa to mol/mol, and the reference must be set to 15 C.        !
      !------------------------------------------------------------------------------------!
      !------ Reference Michaelis-Mentel CO2 coefficient [mol/mol]. -----------------------! 
      kco2_refval   = 30. * mmcod / prefsea / kco2_q10
      !------ Reference Michaelis-Mentel O2 coefficient [mol/mol]. ------------------------! 
      ko2_refval    = 3.e4 * mmo2 * mmdryi / prefsea / ko2_q10
      !------------------------------------------------------------------------------------!



      !------------------------------------------------------------------------------------!
      !   Use the default CO2 compensation point values from C91, based on tau.            !
      !   Gamma* = [O2] / (2. * tau)                                                       !
      !------------------------------------------------------------------------------------!
      compp_refval  = o2_ref * tau_q10 / (2. * tau_refval_c91) ! Reference value [ mol/mol]
      compp_hor     = - tau_hor                                ! "Activation en. [       K]
      compp_q10     = 1. / tau_q10                             ! "Q10" term      [     ---]
      !------------------------------------------------------------------------------------!
   case (3)
      !------------------------------------------------------------------------------------!
      !    Use default CO2 and O2 reference values from C91.  Here we must convert the     !
      ! reference values from Pa to mol/mol, and the reference must be set to 15 C.        !
      !------------------------------------------------------------------------------------!
      !------ Reference Michaelis-Mentel CO2 coefficient [mol/mol]. -----------------------! 
      kco2_refval   = 30. * mmcod / prefsea / kco2_q10
      !------ Reference Michaelis-Mentel O2 coefficient [mol/mol]. ------------------------! 
      ko2_refval    = 3.e4 * mmo2 * mmdryi / prefsea / ko2_q10
      !------------------------------------------------------------------------------------!



      !------------------------------------------------------------------------------------!
      !   Use the default CO2 compensation point values from C91, based on tau.            !
      !   Gamma* = [O2] / (2. * tau)                                                       !
      !------------------------------------------------------------------------------------!
      compp_refval  = kookc * o2_ref * kco2_refval / ko2_refval ! Ref. value     [ mol/mol]
      compp_hor     = kco2_hor - ko2_hor                        ! "Act. energy"  [       K]
      compp_q10     = kco2_q10 / ko2_q10                        ! "Q10" term     [     ---]
      !------------------------------------------------------------------------------------!
   end select
   !---------------------------------------------------------------------------------------! 



   !---------------------------------------------------------------------------------------!
   !    The following parameter is the k coefficient in Foley et al. (1996) that is used   !
   ! to determine the CO2-limited photosynthesis for C4 grasses.  Notice that Foley et al. !
   ! (1996) didn't correct for molar mass (the mmcod term here).                           !
   !---------------------------------------------------------------------------------------!
   klowco2      = klowco2in * mmcod ! coefficient for low CO2                    [ mol/mol]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     These are constants obtained in Leuning et al. (1995) and Collatz et al. (1991)   !
   ! to convert different conductivities.                                                  !
   !---------------------------------------------------------------------------------------!
   gbh_2_gbw  = 1.075           ! heat  to water  - leaf boundary layer
   gbw_2_gbc  = 1.0 / 1.4       ! water to carbon - leaf boundary layer
   gsw_2_gsc  = 1.0 / 1.6       ! water to carbon - stomata
   gsc_2_gsw  = 1./gsw_2_gsc    ! carbon to water - stomata
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     This is the minimum threshold for the photosynthetically active radiation, in     !
   ! �mol/m�/s to consider non-night time conditions (day time or twilight).               !
   !---------------------------------------------------------------------------------------!
   par_twilight_min = 0.5 * Watts_2_Ein ! Minimum non-nocturnal PAR.             [mol/m�/s]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     This is the quantum yield response curve, using equation 2 from E78:              !
   !     The coefficients here are different because his function used temperature in      !
   ! Celsius and here we give the coefficients for temperature in Kelvin.  We don't use    !
   ! this equation for temperatures below 0C, instead we find the equivalent at 0 Celsius  !
   ! and assume it is constant below this temperature.                                     !
   !---------------------------------------------------------------------------------------!
   qyield0            = ehl0 - ehl1 * t00 + ehl2 * t00 * t00
   qyield1            = ehl1 - 2. * ehl2 * t00
   qyield2            = ehl2
   ehleringer_alpha0c = ehl0
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Find the double precision version of the variables above.                          !
   !---------------------------------------------------------------------------------------!
   c34smin_lint_co28   = dble(c34smin_lint_co2  )
   c34smax_lint_co28   = dble(c34smax_lint_co2  )
   c34smax_gsw8        = dble(c34smax_gsw       )
   gbh_2_gbw8          = dble(gbh_2_gbw         )
   gbw_2_gbc8          = dble(gbw_2_gbc         )
   gsw_2_gsc8          = dble(gsw_2_gsc         )
   gsc_2_gsw8          = dble(gsc_2_gsw         )
   kookc8              = dble(kookc             )
   tphysref8           = dble(tphysref          )
   tphysrefi8          = dble(tphysrefi         )
   fcoll8              = dble(fcoll             )
   compp_refval8       = dble(compp_refval      )
   compp_hor8          = dble(compp_hor         )
   compp_q108          = dble(compp_q10         )
   kco2_refval8        = dble(kco2_refval       )
   kco2_hor8           = dble(kco2_hor          )
   kco2_q108           = dble(kco2_q10          )
   ko2_refval8         = dble(ko2_refval        )
   ko2_hor8            = dble(ko2_hor           )
   ko2_q108            = dble(ko2_q10           )
   klowco28            = dble(klowco2           )
   o2_ref8             = dble(o2_ref            )
   par_twilight_min8   = dble(par_twilight_min  )
   qyield08            = dble(qyield0           )
   qyield18            = dble(qyield1           )
   qyield28            = dble(qyield2           )
   ehleringer_alpha0c8 = dble(ehleringer_alpha0c)
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Parameters that control debugging output.                                         !
   !---------------------------------------------------------------------------------------!
   !----- I should print detailed debug information. --------------------------------------!
   print_photo_debug = btest(idetailed,1)
   !----- File name prefix for the detailed information in case of debugging. -------------!
   photo_prefix      = trim(ffilout)//'_photo_state_'
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_physiology_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_hydro_coms

  use hydrology_coms,only:useTOPMODEL,useRUNOFF,HydroOutputPeriod, &
       MoistRateTuning,MoistSatThresh,Moist_dWT,FracLiqRunoff, &
       GrassLAIMax,inverse_runoff_time
  use ed_misc_coms, only: ied_init_mode

  implicit none

  if(ied_init_mode == 3)then
     ! Signifies a restart from an ED2 history file
     useTOPMODEL = 1
     useRUNOFF   = 0
  else
     useTOPMODEL = 0
     useRUNOFF = 0
  endif

  HydroOutputPeriod = 96 !! multiples of dtlsm

  MoistRateTuning = 1.0    

  MoistSatThresh = 0.95     
  
  Moist_dWT = 2.0 

  FracLiqRunoff = 0.5
  
  GrassLAImax = 4.0

  inverse_runoff_time = 0.1

  return
end subroutine init_hydro_coms
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_soil_coms
   use soil_coms      , only : ed_nstyp              & ! intent(in)
                             , isoilflg              & ! intent(in)
                             , nslcon                & ! intent(in)
                             , isoilcol              & ! intent(in)
                             , slxclay               & ! intent(in)
                             , slxsand               & ! intent(in)
                             , soil                  & ! intent(in)
                             , soil_class            & ! type
                             , soilcol               & ! intent(in)
                             , soilcol_class         & ! type
                             , soil8                 & ! intent(out)
                             , water_stab_thresh     & ! intent(out)
                             , snowmin               & ! intent(out)
                             , dewmax                & ! intent(out)
                             , soil_rough            & ! intent(out)
                             , snow_rough            & ! intent(out)
                             , ny07_eq04_a           & ! intent(out)
                             , ny07_eq04_m           & ! intent(out)
                             , tiny_sfcwater_mass    & ! intent(out)
                             , infiltration_method   & ! intent(out)
                             , soil_rough8           & ! intent(out)
                             , snow_rough8           & ! intent(out)
                             , ny07_eq04_a8          & ! intent(out)
                             , ny07_eq04_m8          & ! intent(out)
                             , freezecoef            & ! intent(out)
                             , freezecoef8           & ! intent(out)
                             , sldrain               & ! intent(out)
                             , sldrain8              & ! intent(out)
                             , sin_sldrain           & ! intent(out)
                             , sin_sldrain8          ! ! intent(out)
   use phenology_coms , only : thetacrit             ! ! intent(in)
   use disturb_coms   , only : sm_fire               ! ! intent(in)
   use grid_coms      , only : ngrids                ! ! intent(in)
   use consts_coms    , only : grav                  & ! intent(in)
                             , wdns                  & ! intent(in)
                             , hr_sec                & ! intent(in)
                             , day_sec               & ! intent(in)
                             , pio180                & ! intent(in)
                             , pio1808               ! ! intent(in)

   implicit none
   !----- Local variables. ----------------------------------------------------------------!
   integer                 :: nsoil                  ! Soil texture flag
   integer                 :: ifm                    ! Grid flag
   real(kind=4)            :: ksand                  ! k-factor for sand (de Vries model)
   real(kind=4)            :: ksilt                  ! k-factor for silt (de Vries model)
   real(kind=4)            :: kclay                  ! k-factor for clay (de Vries model)
   real(kind=4)            :: kair                   ! k-factor for air  (de Vries model)
   real(kind=4)            :: slxsilt                ! Silt fraction
   !----- Local constants. ----------------------------------------------------------------!
   real(kind=4), parameter :: fieldcp_K   =  0.1     ! hydr. cond. at field cap.   [mm/day]
   real(kind=4), parameter :: soilcp_MPa  = -3.1     ! Matric pot. - air dry soil  [   MPa]
   real(kind=4), parameter :: soilwp_MPa  = -1.5     ! Matric pot. - wilting point [   MPa]
   real(kind=4), parameter :: sand_hcapv  =  2.128e6 ! Sand vol. heat capacity     [J/m3/K]
   real(kind=4), parameter :: clay_hcapv  =  2.385e6 ! Clay vol. heat capacity     [J/m3/K]
   real(kind=4), parameter :: silt_hcapv  =  2.256e6 ! Silt vol. heat capacity (*) [J/m3/K]
   real(kind=4), parameter :: air_hcapv   =  1.212e3 ! Air vol. heat capacity      [J/m3/K]
   real(kind=4), parameter :: sand_thcond = 8.80     ! Sand thermal conduct.       [ W/m/K]
   real(kind=4), parameter :: clay_thcond = 2.92     ! Clay thermal conduct.       [ W/m/K]
   real(kind=4), parameter :: silt_thcond = 5.87     ! Silt thermal conduct.   (*) [ W/m/K]
   real(kind=4), parameter :: air_thcond  = 0.025    ! Air thermal conduct.        [ W/m/K]
   real(kind=4), parameter :: h2o_thcond  = 0.57     ! Water thermal conduct.      [ W/m/K]
   !---------------------------------------------------------------------------------------!
   ! (*) If anyone has the heat capacity and thermal conductivity for silt, please feel    !
   !     free to add it in here, I didn't find any.  Apparently no one knows, and I've     !
   !     seen in other models that people just assume either the same as sand or the       !
   !     average.  Here I'm just using halfway.  I think the most important thing is to    !
   !     take into account the soil and the air, which are the most different.             !
   !                                                                                       !
   ! Sand (quartz), clay, air, and water heat capacities and thermal conductivities values !
   ! are from:                                                                             !
   !     Monteith and Unsworth, 2008: Environmental Physics.                               !
   !         Academic Press, Third Edition. Table 15.1, p. 292                             !
   !---------------------------------------------------------------------------------------!


   !----- Initialise some standard variables. ---------------------------------------------!
   water_stab_thresh   = 5.0            ! Minimum mass to be considered stable    [   kg/m2]
   snowmin             = 5.0            ! Minimum mass needed to create new layer [   kg/m2]
   dewmax              = 3.0e-5         ! Maximum dew flux rate (deprecated)      [ kg/m2/s]
   soil_rough          = 0.01           ! Soil roughness height                   [       m]
   snow_rough          = 0.0024         ! Snowcover roughness height              [       m]
   tiny_sfcwater_mass  = 1.0e-3         ! Minimum mass in temporary layers        [   kg/m2]
   infiltration_method = 0              ! Infiltration method, used in rk4_derivs [     0|1]
   freezecoef          = 7.0 * log(10.) ! Coeff. for infiltration of frozen water [     ---]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Parameters for fraction covered with snow, which is based on:                     !
   !                                                                                       !
   ! Niu, G.-Y., and Z.-L. Yang (2007), An observation-based formulation of snow cover     !
   !    fraction and its evaluation over large North American river basins,                !
   !    J. Geophys. Res., 112, D21101, doi:10.1029/2007JD008674                            !
   !                                                                                       !
   !    These are the parameters in equation 4.  Fresh snow density is defined at          !
   ! consts_coms.f90                                                                       !
   !---------------------------------------------------------------------------------------!
   ny07_eq04_a = 2.5   ! the coefficient next to soil roughness.
   ny07_eq04_m = 1.0   ! m
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      UPDATED based on Cosby et al. 1984, soil clay and sand fractions from table 2,   !
   ! slpots, slmsts, slbs, and slcons calculated based on table 4 sfldcap calculated based !
   ! on Clapp and Hornberger equation 2 and a soil hydraulic conductivity of 0.1mm/day,    !
   ! soilcp (air dry soil moisture capacity) is calculated based on Cosby et al. 1984      !
   ! equation 1 and a soil-water potential of -3.1MPa.  soilwp (the wilting point soil     !
   ! moisture) is calculated based on Cosby et al 1985 equation 1 and a soil-water poten-  !
   ! tial of -1.5MPa (Equation 1 in Cosby is not correct it should be saturated moisture   !
   ! potential over moisture potential)  (NML, 2/2010)                                     !
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   ! (1st line)          slpots        slmsts          slbs      slcpd        soilcp       !
   ! (2nd line)          soilwp        slcons       slcons0    thcond0       thcond1       !
   ! (3rd line)         thcond2       thcond3       sfldcap      xsand         xclay       !
   ! (4th line)           xsilt       xrobulk      slden        soilld        soilfr       !
   ! (5th line)         slpotwp       slpotfc    slpotld       slpotfr                     !
   !---------------------------------------------------------------------------------------!
   soil = (/                                                                               &
      !----- 1. Sand. ---------------------------------------------------------------------!
       soil_class( -0.049831046,     0.373250,     3.295000,  1342809.,  0.026183447       &
                 ,  0.032636854,  2.446421e-5,  0.000500000, 0.9546011,    0.5333047       &
                 ,    0.6626306,   -0.4678112,  0.132130936,     0.920,        0.030       &
                 ,        0.050,        1200.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 2. Loamy sand. ---------------------------------------------------------------!
      ,soil_class( -0.067406224,     0.385630,     3.794500,  1326165.,  0.041560499       &
                 ,  0.050323046,  1.776770e-5,  0.000600000, 0.9279457,    0.5333047       &
                 ,    0.6860126,   -0.4678112,  0.155181959,     0.825,        0.060       &
                 ,        0.115,        1250.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 3. Sandy loam. ---------------------------------------------------------------!
      ,soil_class( -0.114261521,     0.407210,     4.629000,  1295982.,  0.073495043       &
                 ,  0.085973722,  1.022660e-5,  0.000769000, 0.8826064,    0.5333047       &
                 ,    0.7257838,   -0.4678112,  0.194037750,     0.660,        0.110       &
                 ,        0.230,        1300.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 4. Silt loam. ----------------------------------------------------------------!
      ,soil_class( -0.566500112,     0.470680,     5.552000,  1191975.,  0.150665475       &
                 ,  0.171711257,  2.501101e-6,  0.000010600, 0.7666418,    0.5333047       &
                 ,    0.8275072,   -0.4678112,  0.273082063,     0.200,        0.160       &
                 ,        0.640,        1400.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 5. Loam. ---------------------------------------------------------------------!
      ,soil_class( -0.260075834,     0.440490,     5.646000,  1245546.,  0.125192234       &
                 ,  0.142369513,  4.532431e-6,  0.002200000, 0.8168244,    0.5333047       &
                 ,    0.7834874,   -0.4678112,  0.246915025,     0.410,        0.170       &
                 ,        0.420,        1350.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 6. Sandy clay loam. ----------------------------------------------------------!
      ,soil_class( -0.116869181,     0.411230,     7.162000,  1304598.,  0.136417267       &
                 ,  0.150969505,  6.593731e-6,  0.001500000, 0.8544779,    0.5333047       &
                 ,    0.7504579,   -0.4678112,  0.249629687,     0.590,        0.270       &
                 ,        0.140,        1350.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 7. Silty clay loam. ----------------------------------------------------------!
      ,soil_class( -0.627769194,     0.478220,     8.408000,  1193778.,  0.228171947       &
                 ,  0.248747504,  1.435262e-6,  0.000107000, 0.7330059,    0.5333047       &
                 ,    0.8570124,   -0.4678112,  0.333825332,     0.100,        0.340       &
                 ,        0.560,        1500.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 8. Clayey loam. --------------------------------------------------------------!
      ,soil_class( -0.281968114,     0.446980,     8.342000,  1249582.,  0.192624431       &
                 ,  0.210137962,  2.717260e-6,  0.002200000, 0.7847168,    0.5333047       &
                 ,    0.8116520,   -0.4678112,  0.301335491,     0.320,        0.340       &
                 ,        0.340,        1450.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 9. Sandy clay. ---------------------------------------------------------------!
      ,soil_class( -0.121283019,     0.415620,     9.538000,  1311396.,  0.182198910       &
                 ,  0.196607427,  4.314507e-6,  0.000002167, 0.8273339,    0.5333047       &
                 ,    0.7742686,   -0.4678112,  0.286363001,     0.520,        0.420       &
                 ,        0.060,        1450.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 10. Silty clay. --------------------------------------------------------------!
      ,soil_class( -0.601312179,     0.479090,    10.461000,  1203168.,  0.263228486       &
                 ,  0.282143846,  1.055191e-6,  0.000001033, 0.7164724,    0.5333047       &
                 ,    0.8715154,   -0.4678112,  0.360319788,     0.060,        0.470       &
                 ,        0.470,        1650.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 11. Clay. --------------------------------------------------------------------!
      ,soil_class( -0.299226464,     0.454400,    12.460000,  1259466.,  0.259868987       &
                 ,  0.275459057,  1.307770e-6,  0.000001283, 0.7406805,    0.5333047       &
                 ,    0.8502802,   -0.4678112,  0.353255209,     0.200,        0.600       &
                 ,        0.200,        1700.,     1600.,        0.000,        0.000       &
                 ,        0.000,        0.000,     0.000,        0.000              )      &
      !----- 12. Peat. --------------------------------------------------------------------!
      ,soil_class( -0.534564359,     0.469200,     6.180000,   874000.,  0.167047523       &
                 ,  0.187868805,  2.357930e-6,  0.000008000, 0.7644011,    0.5333047       &
                 ,    0.8294728,   -0.4678112,  0.285709966,    0.2000,       0.2000       &
                 ,       0.6000,         500.,         300.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 13. Bedrock. -----------------------------------------------------------------!
      ,soil_class(    0.0000000,     0.000000,     0.000000,  2130000.,  0.000000000       &
                 ,  0.000000000,  0.000000e+0,  0.000000000, 1.3917897,    0.5333047       &
                 ,    0.2791318,   -0.4678112,  0.000000001,        0.0000        &
                 ,       0.0000,       0.0000,           0.,        0.,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000,        0.000)      &
      !----- 14. Silt. --------------------------------------------------------------------!
      ,soil_class( -1.047128548,     0.492500,     3.862500,  1143842.,  0.112299080       &
                 ,  0.135518820,  2.046592e-6,  0.000010600, 0.7425839,    0.5333047       &
                 ,    0.8486106,   -0.4678112,  0.245247642,     0.075,        0.050       &
                 ,        0.875,        1400.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 15. Heavy clay. --------------------------------------------------------------!
      ,soil_class( -0.322106879,     0.461200,    15.630000,  1264547.,  0.296806035       &
                 ,  0.310916364,  7.286705e-7,  0.000001283, 0.7057374,    0.5333047       &
                 ,    0.8809321,   -0.4678112,  0.382110712,     0.100,        0.800       &
                 ,        0.100,        1700.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 16. Clayey sand. -------------------------------------------------------------!
      ,soil_class( -0.176502150,     0.432325,    11.230000,  1292163.,  0.221886929       &
                 ,  0.236704039,  2.426785e-6,  0.000001283, 0.7859325,    0.5333047       &
                 ,    0.8105855,   -0.4678112,  0.320146708,     0.375,        0.525       &
                 ,        0.100,        1700.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
      !----- 17. Clayey silt. -------------------------------------------------------------!
      ,soil_class( -0.438278332,     0.467825,    11.305000,  1228490.,  0.261376708       &
                 ,  0.278711303,  1.174982e-6,  0.000001283, 0.7281197,    0.5333047       &
                 ,    0.8612985,   -0.4678112,  0.357014719,     0.125,        0.525       &
                 ,        0.350,        1700.,        1600.,     0.000,        0.000       &
                 ,        0.000,        0.000,        0.000,     0.000              )      &
   /)
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !******** Correct soil_class table using sand and clay fractions (if provided)  ********!
   !      Based on Cosby et al 1984, using table 4 and equation 1 (which is incorrect it   !
   ! should be saturated moisture potential over moisture potential).  NML 2/2010          !
   !---------------------------------------------------------------------------------------!
   do ifm=1,ngrids
      if ( isoilflg(ifm)==2 .and. slxclay > 0. .and. slxsand > 0. .and.                    &
           (slxclay + slxsand) <= 1. ) then
         slxsilt              = 1. - slxsand - slxclay
         soil(nslcon)%xsand   = slxsand
         soil(nslcon)%xclay   = slxclay
         soil(nslcon)%xsilt   = slxsilt

         !----- B exponent [unitless]. ----------------------------------------------------!
         soil(nslcon)%slbs    = 3.10 + 15.7*slxclay - 0.3*slxsand

         !----- Soil moisture potential at saturation [ m ]. ------------------------------!
         soil(nslcon)%slpots  = -1. * (10.**(2.17 - 0.63*slxclay - 1.58*slxsand)) * 0.01

         !----- Hydraulic conductivity at saturation [ m/s ]. -----------------------------!
         soil(nslcon)%slcons  = (10.**(-0.60 + 1.26*slxsand - 0.64*slxclay))               &
                              * 0.0254/hr_sec
         !----- Hydraulic conductivity at saturation at top [ m/s ], for TOPMODEL style. --!
         
         !----- Soil moisture at saturation [ m^3/m^3 ]. ----------------------------------!
         soil(nslcon)%slmsts  = (50.5 - 14.2*slxsand - 3.7*slxclay) / 100.
         !----- Soil field capacity[ m^3/m^3 ]. -------------------------------------------!
         soil(nslcon)%sfldcap = soil(nslcon)%slmsts                                        &
                              *  ( (fieldcp_K/wdns/day_sec)/soil(nslcon)%slcons)           &
                              ** (1. / (2.*soil(nslcon)%slbs+3.))
         !----- Dry soil capacity (at -3.1MPa) [ m^3/m^3 ]. -------------------------------!
         soil(nslcon)%soilcp  = soil(nslcon)%slmsts                                        &
                              *  ( soil(nslcon)%slpots / (soilcp_MPa * wdns / grav))       &
                              ** (1. / soil(nslcon)%slbs)
         !----- Wilting point capacity (at -1.5MPa) [ m^3/m^3 ]. --------------------------!
         soil(nslcon)%soilwp  = soil(nslcon)%slmsts                                        &
                              *  ( soil(nslcon)%slpots / (soilwp_MPa * wdns / grav))       &
                              ** ( 1. / soil(nslcon)%slbs)
         !---------------------------------------------------------------------------------!

         !---------------------------------------------------------------------------------!
         !     Heat capacity.  Here we take the volume average amongst silt, clay, and     !
         ! sand, and consider the contribution of air sitting in.  In order to keep it     !
         ! simple, we assume that the air fraction won't change, although in reality its   !
         ! contribution should be a function of soil moisture.  Here we use the amount of  !
         ! air in case the soil moisture was halfway between dry air and saturated, so the !
         ! error is not too biased.                                                        !
         !---------------------------------------------------------------------------------!
         soil(nslcon)%slcpd   = (1. - soil(nslcon)%slmsts)                                 &
                              * ( slxsand * sand_hcapv + slxsilt * silt_hcapv              &
                                + slxclay * clay_hcapv )                                   &
                              + 0.5 * (soil(nslcon)%slmsts - soil(nslcon)%soilcp)          &
                              * air_hcapv
         !---------------------------------------------------------------------------------!


         !---------------------------------------------------------------------------------!
         !      Thermal conductivity is the weighted average of thermal conductivities of  !
         ! all materials, although a further weighting factor due to thermal gradient of   !
         ! different materials.  We use the de Vries model described at:                   !
         !                                                                                 !
         ! Camillo, P., T.J. Schmugge, 1981: A computer program for the simulation of heat !
         !     and moisture flow in soils, NASA-TM-82121, Greenbelt, MD, United States.    !
         !                                                                                 !
         ! Parlange, M.B., et al., 1998: Review of heat and water movement in field soils, !
         !    Soil Till. Res., 47(1-2), 5-10.                                              !
         !                                                                                 !
         !---------------------------------------------------------------------------------!
         !---- The k-factors, assuming spherical particles. -------------------------------!
         ksand = 3. * h2o_thcond / ( 2. * h2o_thcond + sand_thcond )
         ksilt = 3. * h2o_thcond / ( 2. * h2o_thcond + silt_thcond )
         kclay = 3. * h2o_thcond / ( 2. * h2o_thcond + clay_thcond )
         kair  = 3. * h2o_thcond / ( 2. * h2o_thcond +  air_thcond )
         !---- The conductivity coefficients. ---------------------------------------------!
         soil(nslcon)%thcond0 = (1. - soil(nslcon)%slmsts )                                &
                              * ( ksand * slxsand * sand_thcond                            &
                                + ksilt * slxsilt * silt_thcond                            &
                                + kclay * slxclay * clay_thcond )                          &
                              + soil(nslcon)%slmsts * kair * air_thcond
         soil(nslcon)%thcond1 = h2o_thcond - kair * air_thcond
         soil(nslcon)%thcond2 = (1. - soil(nslcon)%slmsts )                                &
                              * ( ksand * slxsand + ksilt * slxsilt + kclay * slxclay )    &
                              + soil(nslcon)%slmsts * kair
         soil(nslcon)%thcond3 = 1. - kair
         !---------------------------------------------------------------------------------!
      end if
   end do
   !---------------------------------------------------------------------------------------!





   !---------------------------------------------------------------------------------------!
   !     Find two remaining properties, that depend on the user choices.                   !
   ! SOILLD -- the critical soil moisture below which drought deciduous plants start drop- !
   !           ping their leaves.  The sign of input variable THETACRIT matters here.  If  !
   !           the user gave a positive number (or 0),  then the soil moisture is a        !
   !           fraction above wilting point.  If it is negative, the value is the          !
   !           potential in MPa.  This is not done for bedrock because it doesn't make     !
   !           sense.                                                                      !
   ! SOILFR -- the critical soil moisture below which fires may happen, provided that the  !
   !           user wants fires, and that there is enough biomass to burn.  The sign of    !
   !           the input variable SM_FIRE matters here.  If the user gave a positive       !
   !           number (or 0), then the soil moisture is a fraction above dry air soil.  If !
   !           it is negative, the value is the potential in MPa.  This is not done for    !
   !           bedrock because it doesn't make sense.                                      !
   !                                                                                       !
   !     And find these two remaining properties:                                          !
   ! SLPOTWP -- Soil potential at wilting point                                            !
   ! SLPOTFC -- Soil potential at field capacity                                           !
   ! SLPOTLD -- Soil potential at leaf drop critical soil moisture                         !
   !---------------------------------------------------------------------------------------!
   do nsoil=1,ed_nstyp
      select case (nsoil)
      case (13)
         soil(nsoil)%soilld  = 0.0
         soil(nsoil)%soilfr  = 0.0
         soil(nsoil)%slpotwp = 0.0
         soil(nsoil)%slpotfc = 0.0
         soil(nsoil)%slpotfr = 0.0
      case default
         !---------------------------------------------------------------------------------!
         !  Critical point for leaf drop.                                                  !
         !---------------------------------------------------------------------------------!
         if (thetacrit >= 0.0) then
            !----- Soil moisture fraction. ------------------------------------------------!
            soil(nsoil)%soilld = soil(nsoil)%soilwp                                        &
                               + thetacrit * (soil(nsoil)%slmsts - soil(nsoil)%soilwp)
         else
            !----- Water potential. -------------------------------------------------------!
            soil(nsoil)%soilld = soil(nsoil)%slmsts                                        &
                               *  ( soil(nsoil)%slpots / (thetacrit * 1000. / grav))       &
                               ** ( 1. / soil(nsoil)%slbs)
         end if
         !---------------------------------------------------------------------------------!



         !---------------------------------------------------------------------------------!
         !  Critical point for fire.                                                       !
         !---------------------------------------------------------------------------------!
         if (sm_fire >= 0.0) then
            !----- Soil moisture fraction. ------------------------------------------------!
            soil(nsoil)%soilfr = soil(nsoil)%soilcp                                        &
                               + sm_fire * (soil(nsoil)%slmsts - soil(nsoil)%soilcp)
         else
            !----- Water potential. -------------------------------------------------------!
            soil(nsoil)%soilfr = soil(nsoil)%slmsts                                        &
                               *  ( soil(nsoil)%slpots / (sm_fire * 1000. / grav))         &
                               ** ( 1. / soil(nsoil)%slbs)
         end if
         !---------------------------------------------------------------------------------!



         !---------------------------------------------------------------------------------!
         !  Soil potential at wilting point and field capacity.                            !
         !---------------------------------------------------------------------------------!
         soil(nsoil)%slpotwp = soil(nsoil)%slpots                                          &
                             / (soil(nsoil)%soilwp  / soil(nsoil)%slmsts)                  &
                             ** soil(nsoil)%slbs
         soil(nsoil)%slpotfr = soil(nsoil)%slpots                                          &
                             / (soil(nsoil)%soilfr  / soil(nsoil)%slmsts)                  &
                             ** soil(nsoil)%slbs
         soil(nsoil)%slpotfc = soil(nsoil)%slpots                                          &
                             / (soil(nsoil)%sfldcap / soil(nsoil)%slmsts)                  &
                             ** soil(nsoil)%slbs
         soil(nsoil)%slpotld = soil(nsoil)%slpots                                          &
                             / (soil(nsoil)%soilld  / soil(nsoil)%slmsts)                  &
                             ** soil(nsoil)%slbs
         !---------------------------------------------------------------------------------!

      end select
   end do
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Fill in the albedo information regarding the soil colour classes.                 !
   !---------------------------------------------------------------------------------------!
   !                    |    Dry soil   |   Saturated   | Emis. |                          !
   !   Soil class       |---------------+---------------|-------|                          !
   !                    |   VIS |   NIR |   VIS |   NIR |   TIR |                          !
   !---------------------------------------------------------------------------------------!
   soilcol = (/                                                     & !
       soilcol_class   (    0.36,   0.61,   0.25,   0.50,   0.98 )  & ! 01 - Brightest
      ,soilcol_class   (    0.34,   0.57,   0.23,   0.46,   0.98 )  & ! 02
      ,soilcol_class   (    0.32,   0.53,   0.21,   0.42,   0.98 )  & ! 03
      ,soilcol_class   (    0.31,   0.51,   0.20,   0.40,   0.98 )  & ! 04
      ,soilcol_class   (    0.30,   0.49,   0.19,   0.38,   0.98 )  & ! 05
      ,soilcol_class   (    0.29,   0.48,   0.18,   0.36,   0.98 )  & ! 06
      ,soilcol_class   (    0.28,   0.45,   0.17,   0.34,   0.98 )  & ! 07
      ,soilcol_class   (    0.27,   0.43,   0.16,   0.32,   0.98 )  & ! 08
      ,soilcol_class   (    0.26,   0.41,   0.15,   0.30,   0.98 )  & ! 09
      ,soilcol_class   (    0.25,   0.39,   0.14,   0.28,   0.98 )  & ! 10
      ,soilcol_class   (    0.24,   0.37,   0.13,   0.26,   0.98 )  & ! 11
      ,soilcol_class   (    0.23,   0.35,   0.12,   0.24,   0.98 )  & ! 12
      ,soilcol_class   (    0.22,   0.33,   0.11,   0.22,   0.98 )  & ! 13
      ,soilcol_class   (    0.20,   0.31,   0.10,   0.20,   0.98 )  & ! 14
      ,soilcol_class   (    0.18,   0.29,   0.09,   0.18,   0.98 )  & ! 15
      ,soilcol_class   (    0.16,   0.27,   0.08,   0.16,   0.98 )  & ! 16
      ,soilcol_class   (    0.14,   0.25,   0.07,   0.14,   0.98 )  & ! 17
      ,soilcol_class   (    0.12,   0.23,   0.06,   0.12,   0.98 )  & ! 18
      ,soilcol_class   (    0.10,   0.21,   0.05,   0.10,   0.98 )  & ! 19
      ,soilcol_class   (    0.08,   0.16,   0.04,   0.08,   0.98 )  & ! 20 - Darkest
      ,soilcol_class   (    0.00,   0.00,   0.00,   0.00,   0.98 )  & ! 21 - ED-2.1, unused
   /)
   !---------------------------------------------------------------------------------------!



   !----- Here we fill soil8, which will be used in Runge-Kutta (double precision). -------!
   do nsoil=1,ed_nstyp
      soil8(nsoil)%slpots    = dble(soil(nsoil)%slpots   )
      soil8(nsoil)%slmsts    = dble(soil(nsoil)%slmsts   )
      soil8(nsoil)%slbs      = dble(soil(nsoil)%slbs     )
      soil8(nsoil)%slcpd     = dble(soil(nsoil)%slcpd    )
      soil8(nsoil)%soilcp    = dble(soil(nsoil)%soilcp   )
      soil8(nsoil)%soilwp    = dble(soil(nsoil)%soilwp   )
      soil8(nsoil)%slcons    = dble(soil(nsoil)%slcons   )
      soil8(nsoil)%slcons0   = dble(soil(nsoil)%slcons0  )
      soil8(nsoil)%thcond0   = dble(soil(nsoil)%thcond0  )
      soil8(nsoil)%thcond1   = dble(soil(nsoil)%thcond1  )
      soil8(nsoil)%thcond2   = dble(soil(nsoil)%thcond2  )
      soil8(nsoil)%thcond3   = dble(soil(nsoil)%thcond3  )
      soil8(nsoil)%sfldcap   = dble(soil(nsoil)%sfldcap  )
      soil8(nsoil)%xsand     = dble(soil(nsoil)%xsand    )
      soil8(nsoil)%xclay     = dble(soil(nsoil)%xclay    )
      soil8(nsoil)%xsilt     = dble(soil(nsoil)%xsilt    )
      soil8(nsoil)%xrobulk   = dble(soil(nsoil)%xrobulk  )
      soil8(nsoil)%slden     = dble(soil(nsoil)%slden    )
      soil8(nsoil)%soilld    = dble(soil(nsoil)%soilld   )
      soil8(nsoil)%soilfr    = dble(soil(nsoil)%soilfr   )
      soil8(nsoil)%slpotwp   = dble(soil(nsoil)%slpotwp  )
      soil8(nsoil)%slpotfc   = dble(soil(nsoil)%slpotfc  )
      soil8(nsoil)%slpotld   = dble(soil(nsoil)%slpotld  )
      soil8(nsoil)%slpotfr   = dble(soil(nsoil)%slpotfr  )
   end do
   soil_rough8  = dble(soil_rough )
   snow_rough8  = dble(snow_rough )
   ny07_eq04_a8 = dble(ny07_eq04_a)
   ny07_eq04_m8 = dble(ny07_eq04_m) 
   freezecoef8  = dble(freezecoef )

   !---------------------------------------------------------------------------------------!
   !     Find the double precision version of the drainage slope, and find and save the    !
   ! sine of it.                                                                           !
   !---------------------------------------------------------------------------------------!
   sldrain8     = dble(sldrain)
   sin_sldrain  = sin(sldrain  * pio180 )
   sin_sldrain8 = sin(sldrain8 * pio1808)
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_soil_coms
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine init_phen_coms
   use consts_coms   , only : erad                     & ! intent(in)
                            , pio180                   ! ! intent(in)
   use phenology_coms, only : radint                   & ! intent(in)
                            , radslp                   & ! intent(in)
                            , thetacrit                & ! intent(in)
                            , retained_carbon_fraction & ! intent(out)
                            , elongf_min               & ! intent(out)
                            , elongf_flush             & ! intent(out)
                            , spot_phen                & ! intent(out)
                            , dl_tr                    & ! intent(out)
                            , st_tr1                   & ! intent(out)
                            , st_tr2                   & ! intent(out)
                            , phen_a                   & ! intent(out)
                            , phen_b                   & ! intent(out)
                            , phen_c                   & ! intent(out)
                            , max_phenology_dist       & ! intent(out)
                            , turnamp_window           & ! intent(out)
                            , turnamp_wgt              & ! intent(out)
                            , turnamp_min              & ! intent(out)
                            , turnamp_max              & ! intent(out)
                            , radto_min                & ! intent(out)
                            , radto_max                & ! intent(out)
                            , llspan_window            & ! intent(out)
                            , llspan_wgt               & ! intent(out)
                            , llspan_min               & ! intent(out)
                            , llspan_max               & ! intent(out)
                            , llspan_inf               & ! intent(out)
                            , vm0_window               & ! intent(out)
                            , vm0_wgt                  & ! intent(out)
                            , vm0_tran                 & ! intent(out)
                            , vm0_slope                & ! intent(out)
                            , vm0_amp                  & ! intent(out)
                            , vm0_min                  ! ! intent(out)

   implicit none

   !---------------------------------------------------------------------------------------!
   !     Before plants drop their leaves, they retain this fraction of their leaf carbon   !
   ! and nitrogen and put it into storage.                                                 !
   !---------------------------------------------------------------------------------------!
   retained_carbon_fraction = 0.5
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Minimum elongation factor before plants give up completely and shed all remain-  !
   ! ing leaves.                                                                           !
   !---------------------------------------------------------------------------------------!
   elongf_min               = 0.05
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Minimum elongation factor that allows plants to start flushing out new leaves if !
   ! they are drought deciduous and have been losing leaves.                               !
   !---------------------------------------------------------------------------------------!
   elongf_flush             = 0.25
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Flag that checks whether to Use soil potential rather than soil moisture to drive !
   ! phenology.                                                                            !
   !---------------------------------------------------------------------------------------!
   spot_phen                = thetacrit < 0.
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Leaf offset parameters are from:                                                 !
   !      White et al. 1997, Global Biogeochemical Cycles 11(2) 217-234                    !
   !---------------------------------------------------------------------------------------!
   dl_tr                    = 655.0
   st_tr1                   = 284.3
   st_tr2                   = 275.15
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Phenology parameters for cold deciduous trees:                                   !
   !      Botta et al. 2000, Global Change Biology, 6, 709--725                            !
   !---------------------------------------------------------------------------------------!
   phen_a                   = -68.0
   phen_b                   = 638.0
   phen_c                   = -0.01
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !     This variable is the maximum distance between the coordinates of a prescribed     !
   ! phenology file and the actual polygon that we will still consider close enough to be  !
   ! representative.  If the user wants to run with prescribed phenology and the closest   !
   ! file is farther away from the polygon than the number below, the simulation will      !
   ! stop.                                                                                 !
   !---------------------------------------------------------------------------------------!
   max_phenology_dist       = 1.25 * erad * pio180
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !      Variables controlling the light phenology as in Kim et al. (20??)                !
   !---------------------------------------------------------------------------------------!
   !----- Turnover window for running average [days] --------------------------------------!
   turnamp_window = 10.
   !----- Turnover weight, the inverse of the window. -------------------------------------!
   turnamp_wgt    = 1. / turnamp_window
   !----- Minimum instantaneous turnover rate amplitude [n/d]. ----------------------------!
   turnamp_min    = 0.01
   !----- Maximum instantaneous turnover rate amplitude [n/d]. ----------------------------!
   turnamp_max    = 100.
   !----- Minimum radiation [W/m2], below which the turnover no longer responds. ----------!
   radto_min       = (turnamp_min - radint) / radslp
   !----- Maximum radiation [W/m2], above which the turnover no longer responds. ----------!
   radto_max       = (turnamp_max - radint) / radslp
   !----- Lifespan window for running average [days]. -------------------------------------!
   llspan_window   = 60.
   !----- Lifespan weight, the inverse of the window. -------------------------------------!
   llspan_wgt      = 1. / llspan_window
   !----- Minimum instantaneous life span [months]. ---------------------------------------!
   llspan_min      = 2.0
   !----- Maximum instantaneous life span [months]. ---------------------------------------!
   llspan_max      = 60.
   !----- Instantaneous life span in case the turnover rate is 0. -------------------------!
   llspan_inf      = 9999.
   !----- Vm0 window for running average [days]. ------------------------------------------!
   vm0_window      = 60.
   !----- Vm0 weight, the inverse of the window. ------------------------------------------!
   vm0_wgt         = 1. / vm0_window
   !----- Parameters that define the instantaneous Vm0 as a function of leaf life span. ---!
   vm0_tran        =1.98    ! 8.5  
   vm0_slope       =6.53    ! 7.0  
   vm0_amp         =57.2    ! 42.0 
   vm0_min         = 7.31   ! 18.0 
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_phen_coms
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!     This subroutine assigns the fusion and splitting parameters.                         !
!------------------------------------------------------------------------------------------!
subroutine init_ff_coms
   use fusion_fission_coms, only : niter_patfus              & ! intent(out)
                                 , hgt_class                 & ! intent(out)
                                 , fusetol                   & ! intent(out)
                                 , fusetol_h                 & ! intent(out)
                                 , lai_fuse_tol              & ! intent(out)
                                 , lai_tol                   & ! intent(out)
                                 , ff_nhgt                   & ! intent(out)
                                 , min_oldgrowth             & ! intent(out)
                                 , coh_tolerance_max         & ! intent(out)
                                 , dark_cumlai_min           & ! intent(out)
                                 , dark_cumlai_max           & ! intent(out)
                                 , dark_cumlai_mult          & ! intent(out)
                                 , sunny_cumlai_min          & ! intent(out)
                                 , sunny_cumlai_max          & ! intent(out)
                                 , sunny_cumlai_mult         & ! intent(out)
                                 , light_toler_min           & ! intent(out)
                                 , light_toler_max           & ! intent(out)
                                 , light_toler_mult          & ! intent(out)
                                 , fuse_relax                & ! intent(out)
                                 , corr_patch                & ! intent(out)
                                 , corr_cohort               & ! intent(out)
                                 , print_fuse_details        & ! intent(out)
                                 , fuse_prefix               ! ! intent(out)
   use consts_coms        , only : onethird                  & ! intent(out)
                                 , twothirds                 & ! intent(in)
                                 , onesixth                  & ! intent(in)
                                 , tiny_num                  & ! intent(in)
                                 , huge_num                  ! ! intent(in)
   use disturb_coms       , only : treefall_disturbance_rate ! ! intent(in)
   use ed_max_dims        , only : n_dist_types              ! ! intent(in)
   implicit none
   !----- Local variables. ----------------------------------------------------------------!
   real              :: exp_patfus
   !---------------------------------------------------------------------------------------!

   fusetol           = 0.4
   fusetol_h         = 0.5
   lai_fuse_tol      = 0.8
   lai_tol           = 1.0
   ff_nhgt           = 8
   coh_tolerance_max = 10.0    ! Original 2.0

   !----- Define the number of height classes. --------------------------------------------!
   allocate (hgt_class(ff_nhgt))
   hgt_class( 1) =  0.0
   hgt_class( 2) =  2.5
   hgt_class( 3) =  7.5
   hgt_class( 4) = 12.5
   hgt_class( 5) = 17.5
   hgt_class( 6) = 22.5
   hgt_class( 7) = 27.5
   hgt_class( 8) = 32.5

   niter_patfus       = 100
   exp_patfus         = 1. / real(niter_patfus-1)

   dark_cumlai_min    = 5.5
   dark_cumlai_max    = 8.0
   sunny_cumlai_min   = 0.1
   sunny_cumlai_max   = 0.3
   light_toler_min    = 0.01
   light_toler_max    = onethird

   sunny_cumlai_mult  = (sunny_cumlai_max/sunny_cumlai_min)**exp_patfus
   dark_cumlai_mult   = (dark_cumlai_min /dark_cumlai_max )**exp_patfus
   light_toler_mult   = (light_toler_max /light_toler_min )**exp_patfus

   fuse_relax        = .false.

   !---------------------------------------------------------------------------------------!
   !      Coefficient of correlation assumed between two patches and cohorts that are      !
   ! about to be fused.                                                                    !
   !---------------------------------------------------------------------------------------!
   corr_patch  = 1.0
   corr_cohort = 1.0
   !---------------------------------------------------------------------------------------!


   !----- The following flag switches detailed debugging on. ------------------------------!
   print_fuse_details = .false.
   fuse_prefix        = 'patch_fusion_'
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Find the minimum age above which we disregard the disturbance type because the    !
   ! patch can be considered old growth.                                                   !
   !---------------------------------------------------------------------------------------!
   !----- Non-cultivated patches: use the mean age for tree fall disturbances. ------------!
   if (abs(treefall_disturbance_rate) > tiny_num) then
      min_oldgrowth(:) = 1. / abs(treefall_disturbance_rate)
   else
      min_oldgrowth(:) = huge_num
   end if
   !----- Cultivated lands should never be fused with non-cultivated lands. ---------------!
   min_oldgrowth(1) = huge_num
   min_oldgrowth(2) = huge_num
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_ff_coms
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine assigns various parameters for the Runge-Kutta solver.  It uses many  !
! values previously assigned in other parameter initialisation, so this should be the last !
! one called.                                                                              !
!------------------------------------------------------------------------------------------!
subroutine init_rk4_params()
   use soil_coms      , only : water_stab_thresh      & ! intent(in)
                             , snowmin                & ! intent(in)
                             , tiny_sfcwater_mass     ! ! intent(in)
   use canopy_air_coms, only : leaf_drywhc            & ! intent(in)
                             , leaf_maxwhc            ! ! intent(in)
   use ed_misc_coms,only     : ffilout                ! ! intent(in)
   use met_driver_coms, only : prss_min               & ! intent(in)
                             , prss_max               ! ! intent(in)
   use consts_coms    , only : wdnsi8                 ! ! intent(in)
   use detailed_coms  , only : idetailed              ! ! intent(in)
   use rk4_coms       , only : rk4_tolerance          & ! intent(in)
                             , ibranch_thermo         & ! intent(in)
                             , maxstp                 & ! intent(out)
                             , rk4eps                 & ! intent(out)
                             , rk4eps2                & ! intent(out)
                             , rk4epsi                & ! intent(out)
                             , hmin                   & ! intent(out)
                             , print_diags            & ! intent(out)
                             , checkbudget            & ! intent(out)
                             , debug                  & ! intent(out)
                             , toocold                & ! intent(out)
                             , toohot                 & ! intent(out)
                             , lai_to_cover           & ! intent(out)
                             , rk4min_veg_temp        & ! intent(out)
                             , rk4water_stab_thresh   & ! intent(out)
                             , rk4tiny_sfcw_mass      & ! intent(out)
                             , rk4tiny_sfcw_depth     & ! intent(out)
                             , rk4leaf_drywhc         & ! intent(out)
                             , rk4leaf_maxwhc         & ! intent(out)
                             , rk4snowmin             & ! intent(out)
                             , rk4min_can_temp        & ! intent(out)
                             , rk4max_can_temp        & ! intent(out)
                             , rk4min_can_shv         & ! intent(out)
                             , rk4max_can_shv         & ! intent(out)
                             , rk4min_can_rhv         & ! intent(out)
                             , rk4max_can_rhv         & ! intent(out)
                             , rk4min_can_co2         & ! intent(out)
                             , rk4max_can_co2         & ! intent(out)
                             , rk4min_soil_temp       & ! intent(out)
                             , rk4max_soil_temp       & ! intent(out)
                             , rk4min_veg_temp        & ! intent(out)
                             , rk4max_veg_temp        & ! intent(out)
                             , rk4min_veg_lwater      & ! intent(out)
                             , rk4min_sfcw_temp       & ! intent(out)
                             , rk4max_sfcw_temp       & ! intent(out)
                             , rk4min_sfcw_moist      & ! intent(out)
                             , rk4min_virt_moist      & ! intent(out)
                             , effarea_heat           & ! intent(out)
                             , effarea_evap           & ! intent(out)
                             , effarea_transp         & ! intent(out)
                             , leaf_intercept         & ! intent(out)
                             , supersat_ok            & ! intent(out)
                             , record_err             & ! intent(out)
                             , print_detailed         & ! intent(out)
                             , print_budget           & ! intent(out)
                             , print_thbnd            & ! intent(out)
                             , errmax_fout            & ! intent(out)
                             , sanity_fout            & ! intent(out)
                             , thbnds_fout            & ! intent(out)
                             , detail_pref            & ! intent(out)
                             , budget_pref            ! ! intent(out)
   use ed_misc_coms   , only : fast_diagnostics       ! ! intent(inout)
   implicit none

   !---------------------------------------------------------------------------------------!
   !     Copying some variables to the Runge-Kutta counterpart (double precision).         !
   !---------------------------------------------------------------------------------------!
   rk4water_stab_thresh  = dble(water_stab_thresh )
   rk4tiny_sfcw_mass     = dble(tiny_sfcwater_mass)
   rk4leaf_drywhc        = dble(leaf_drywhc       )
   rk4leaf_maxwhc        = dble(leaf_maxwhc       )
   rk4snowmin            = dble(snowmin           )
   rk4tiny_sfcw_depth    = rk4tiny_sfcw_mass  * wdnsi8
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !    The following variables control the performance of the Runge-Kutta and Euler       !
   ! integration schemes. Think twice before changing them...                              !
   !---------------------------------------------------------------------------------------!
   maxstp      = 100000000           ! Maximum number of intermediate steps. 
   rk4eps      = dble(rk4_tolerance) ! The desired accuracy.
   rk4epsi     = 1.d0/rk4eps         ! The inverse of desired accuracy.
   rk4eps2     = rk4eps**2           ! square of the accuracy
   hmin        = 1.d-7               ! The minimum step size.
   print_diags = .false.             ! Flag to print the diagnostic check.
   checkbudget = .true.              ! Flag to check CO2, water, and energy budgets every 
                                     !     time step and stop the run in case any of these 
                                     !     budgets don't close.
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Miscellaneous constants used in rk4_derivs.                                       !
   !---------------------------------------------------------------------------------------!
   debug         = .false.  ! Verbose output for debug                             [   T|F]
   toocold       = 1.5315d2 ! Minimum temperature for saturation specific hum.     [     K]
   toohot        = 3.5315d2 ! Maximum temperature for saturation specific hum.     [     K]
   lai_to_cover  = 1.5d0    ! Canopies with LAI less than this number  are assumed to be 
                            !     open, ie, some fraction of the rain-drops can reach
                            !    the soil/litter layer unimpeded.
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Variables used to keep track on the error.  We use the idetailed flag to          !
   ! determine whether to create the output value or not.                                  !
   !---------------------------------------------------------------------------------------!
   !------ Detailed budget (every DTLSM). -------------------------------------------------!
   print_budget   = btest(idetailed,0)
   if (print_budget) checkbudget = .true.
   !------ Detailed output from the integrator (every HDID). ------------------------------!
   print_detailed = btest(idetailed,2)
   !------ Thermodynamic boundaries for sanity check (every HDID). ------------------------!
   print_thbnd    = btest(idetailed,3)
   !------ Daily error statistics (count how often a variable shrunk the time step). ------!
   record_err     = btest(idetailed,4)
   !---------------------------------------------------------------------------------------!
   errmax_fout    = 'error_max_count.txt'    ! File with the maximum error count 
   sanity_fout    = 'sanity_check_count.txt' ! File with the sanity check count
   thbnds_fout    = 'thermo_bounds.txt'      ! File with the thermodynamic boundaries.
   detail_pref    = 'thermo_state_'          ! Prefix for the detailed thermodynamic file
   budget_pref    = 'budget_state_'          ! File with the thermodynamic boundaries.
   !---------------------------------------------------------------------------------------!



   !----- Append the same prefix used for analysis files. ---------------------------------!
   detail_pref = trim(ffilout)//'_'//trim(detail_pref)
   budget_pref = trim(ffilout)//'_'//trim(budget_pref)
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   !     Assigning some default values for the bounds at the sanity check.  Units are      !
   ! usually the standard, but a few of them are defined differently so they can be scaled !
   ! depending on the cohort and soil grid definitions.                                    !
   !---------------------------------------------------------------------------------------!
   rk4min_can_temp   =  1.8400d2  ! Minimum canopy    temperature               [        K]
   rk4max_can_temp   =  3.5100d2  ! Maximum canopy    temperature               [        K]
   rk4min_can_shv    =  1.0000d-8 ! Minimum canopy    specific humidity         [kg/kg_air]
   rk4max_can_shv    =  6.0000d-2 ! Maximum canopy    specific humidity         [kg/kg_air]
   rk4max_can_rhv    =  1.1000d0  ! Maximum canopy    relative humidity (**)    [      ---]
   rk4min_can_co2    =  3.0000d1  ! Minimum canopy    CO2 mixing ratio          [ �mol/mol]
   rk4max_can_co2    =  5.0000d4  ! Maximum canopy    CO2 mixing ratio          [ �mol/mol]
   rk4min_soil_temp  =  1.8400d2  ! Minimum soil      temperature               [        K]
   rk4max_soil_temp  =  3.5100d2  ! Maximum soil      temperature               [        K]
   rk4min_veg_temp   =  1.8400d2  ! Minimum leaf      temperature               [        K]
   rk4max_veg_temp   =  3.5100d2  ! Maximum leaf      temperature               [        K]
   rk4min_sfcw_temp  =  1.9315d2  ! Minimum snow/pond temperature               [        K]
   rk4max_sfcw_temp  =  3.5100d2  ! Maximum snow/pond temperature               [        K]
   !.......................................................................................!
   ! (**) Please, don't be too strict here.  The model currently doesn't have radiation    !
   !      fog, so supersaturation may happen.  This is a problem we may want to address in !
   !      the future, though...                                                            !
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     Minimum water mass at the leaf surface.  This is given in kg/m�leaf rather than   !
   ! kg/m�ground, so we scale it with LAI.                                                 !
   !---------------------------------------------------------------------------------------!
   rk4min_veg_lwater = -rk4leaf_drywhc            ! Minimum leaf water mass     [kg/m�leaf]
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    The minimum mass of surface water and virtual layer are given in m3/m3 rather than !
   ! kg/m2.  This is because there will be exchange between the top soil layer and the     !
   ! layers above in case the mass goes below the minimum.  Since this would make the im-  !
   ! pact of such exchange dependent on the soil depth, we assign the scale a function of  !
   ! the top layer thickness.                                                              !
   !---------------------------------------------------------------------------------------!
   rk4min_sfcw_moist = -5.0000d-4                  ! Minimum water mass allowed.
   rk4min_virt_moist = -5.0000d-4                  ! Minimum water allowed at virtual pool.
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !     These variables are assigned in ed_params.f90.  Heat area should be 2.0 for all   !

   ! PFTs (two sides of the leaves exchange heat), and the evaporation area should be 1.0  !
   ! for all PFTs (only one side of the leaf is usually covered by water).  The transpir-  !
   ! ation area should be 1.0 for hypostomatous leaves, and 2.0 for symmetrical (pines)    !
   ! and amphistomatous (araucarias) leaves.  Sometimes heat and evaporation are multi-    !
   ! plied  by 1.2 and 2.2 to account for branches and twigs.  This is not recommended,    !
   ! though, because branches and twigs do not contribute to heat storage when             !
   ! ibranch_thermo is set to zero, and they are otherwise accounted through the wood area !
   ! index.                                                                                !
   ! changed-KP                                                                            !
   !---------------------------------------------------------------------------------------!
   effarea_heat   = 2.d0 ! Heat area: related to 2*LAI
   effarea_evap   = 1.d0 ! Evaporation area: related to LAI
   !----- Transpiration.  Adjust them to 1 or 2 according to the type of leaf. ------------!
   effarea_transp(1:5)  = 1.d0 ! Hypostomatous
   effarea_transp(6:8)  = 2.d0 ! Symmetrical
   effarea_transp(9:16) = 1.d0 ! Hypostomatous
   effarea_transp(17)   = 2.d0 ! Amphistomatous
   effarea_transp(18)   = 2.d0 ! Amphistomatous
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    This flag is used to control evaporation and transpiration when the air is         !
   ! saturated or super-saturated.  If supersat_ok is TRUE, then evaporation and           !
   ! transpiration will continue to happen even if the air is super-saturated at the       !
   ! canopy air temperature (but not at the soil or vegetation temperature).  Otherwise,   !
   ! evaporation and transpiration will be interrupted until the air becomes sub-saturated !
   ! again.  The air can still become super-saturated because mixing with the free atmo-   !
   ! sphere will not stop, but that is unlikely.                                           !
   !---------------------------------------------------------------------------------------!
   supersat_ok = .false.
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     This flag is to turn on and on the leaf interception.  Except for developer       !
   ! tests, this variable should be always true.                                           !
   !---------------------------------------------------------------------------------------!
   leaf_intercept = .true.
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !      Update fast_diagnostics in case checkbudget is set to true.                      !
   !---------------------------------------------------------------------------------------!
   fast_diagnostics = fast_diagnostics .or. checkbudget
   !---------------------------------------------------------------------------------------!

   return
end subroutine init_rk4_params
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
subroutine overwrite_with_xml_config(thisnode)
   !!! PARSE XML FILE
   use ed_max_dims,   only: n_pft
   use ed_misc_coms,  only: iedcnfgf
   use hydrology_coms,only: useTOPMODEL
   use soil_coms,     only: isoilbc
   implicit none
   integer, intent(in) :: thisnode
   integer             :: max_pft_xml
   logical             :: iamhere

   if (iedcnfgf /= '') then
      inquire (file=iedcnfgf,exist=iamhere)
      if (iamhere) then

         !! FIRST, determine number of pft's defined in xml file
         call count_pft_xml_config(trim(iedcnfgf),max_pft_xml)
         if(max_pft_xml > n_pft) then

            write(unit=*,fmt='(a)') '*********************************************'
            write(unit=*,fmt='(a)') '**                                         **'
            write(unit=*,fmt='(a)') '**  Number of PFTs required by XML Config  **'
            write(unit=*,fmt='(a)') '**  exceeds the memory available           **'
            write(unit=*,fmt='(a)') '**                                         **'
            write(unit=*,fmt='(a)') '**  Please change n_pft in Module ed_max_dims **'
            write(unit=*,fmt='(a)') '**  and recompile                          **'
            write(unit=*,fmt='(a)') '**                                         **'
            write(unit=*,fmt='(a)') '*********************************************'
            call fatal_error('Too many PFTs','overwrite_with_xml_config','ed_params.f90')
         end if

         !! SECOND, update parameter defaults from XML
         call read_ed_xml_config(trim(iedcnfgf))

         !! THIRD, recalculate any derived values based on xml
         if(useTOPMODEL == 1) then
            isoilbc = 0
            print*,"TOPMODEL enabled, setting ISOILBC to 0"
         end if


         !! FINALLY, write out copy of settings
         call write_ed_xml_config()
   !      stop
      elseif (thisnode == 1) then
            write(unit=*,fmt='(a)') '*********************************************'
            write(unit=*,fmt='(a)') '**               WARNING!                  **'
            write(unit=*,fmt='(a)') '**                                         **'
            write(unit=*,fmt='(a)') '**    XML file wasn''t found. Using default **'
            write(unit=*,fmt='(a)') '** parameters in ED.                       **'
            write(unit=*,fmt='(a)') '** (You provided '//trim(iedcnfgf)//').'
            write(unit=*,fmt='(a)') '**                                         **'
            write(unit=*,fmt='(a)') '*********************************************'
      end if
   end if  !! end XML
   return
end subroutine overwrite_with_xml_config
!==========================================================================================!
!==========================================================================================!
