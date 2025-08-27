# i_Boiler_Plate
Boiler Plate code for the IBM i
IBMi Boiler Plate code examples This repository was built to share code examples. 1. List Box Examples. This shows how to use Embeded SQL in SQLRPGLE to build a dataset that is used to display a selection screen. There are four examples two with single selections and two with multiple selections. Two have position to logic. 2. An example program that demonstrates how SORTA(D) is used against a dataset. 3. An example program that demonstrates how to use qsort for sorting multiple columns in a dataset.
Updated 8/30/2025 - Modules BPMLB01 - BPMLB04:
  Cleaned up the SQL to retrieve the data - Put the entire process in one function.
  Expanded the windows to be able to display *More/*Bottom.
  Fixed the Build Subfile procedure to put the data structure array position logic inside the subfile "For" loop to capture the last subfile record number correctly.
  Adjusted the "Page Down" to work correctly based on the last subfile record written.
