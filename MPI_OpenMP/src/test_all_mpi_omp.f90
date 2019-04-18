!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   18 April 2019
!
! Author:
!
!   Rui Zhang
!
!==============================================================================
!
!>P test_all_mpi_omp
!   Entry point for the unified test of mpi and openmp hybird code.
!
!   Runs all the tests
!
    
    program test_all_mpi_omp
    
        !mpi unit
        use mpi_mod
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit    
        !test unit
        use test_mpiomphelloworld, only: mpiomphelloworld
        !++

        implicit none

        !MPI relevant
        integer             :: required,provided
        !..
        integer             :: n_errors  !number of errors

        n_errors = 0
        
        !whether all threads are allowed to make MPI calls
        required = MPI_THREAD_MULTIPLE
        !-----------------------------------------------------------------------------------------------
        !   MPI_THREAD_SINGLE  | 0 | MPI���̽���һ���߳�ִ�У�����ǰ���л�����MPI���̲�֧�ֶ��߳�ִ��   |
        !  MPI_THREAD_FUNNELED | 1 | MPI���̿����ɶ���߳�ִ�У���ֻ�����߳��ܵ���MPI����               |
        ! MPI_THREAD_SERIALIZED| 2 | MPI���̿����ɶ���߳�ִ�У������߳��ܵ���MPI������������ͬʱ����   |
        !  MPI_THREAD_MULTIPLE | 3 | MPI���̿����ɶ���߳�ִ�У������߳���������ʱ�̵���MPI����         |
        !-----------------------------------------------------------------------------------------------
        
        !cheack thread safe mode
        call mpi_init_thread( required,provided,err )
        if ( provided<required ) then
            write( error_unit,'(A,I2,A)' ) 'Required MPI thread safe mode',required,' is not supported.'
            stop
        endif
        
        call mpi_comm_rank( mpi_comm_world,pid,err )

        myid = pid+1
        call mpi_comm_size( mpi_comm_world,num_p,err )

        if ( pid==root ) then
            pause
            write ( output_unit,'(A)' ) 'MPI TEST:'
        endif
    
        call mpi_barrier( mpi_comm_world,err )
        
        !..helloworld
        call mpiomphelloworld
        call mpi_barrier( mpi_comm_world,err )
        
        !..++
    
        call mpi_finalize( err )

    end program test_all_mpi_omp
!*****************************************************************************************