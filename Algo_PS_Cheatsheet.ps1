###############################################
#  POWERSHELL CHEATSHEET ALGO EDITION         #
#  Author: Far_n_y                            #
#  Powershell 5.1                             #
#  License: GNU General Public License v2.0   #
#  URL: https://github.com/farnysec/Powercheat#
###############################################


#FIBONACCI NUMBER
================================================================================

$previous2_value = 0 ; $previous1_value = 1 ; $previous2_value ; $previous1_value
for ($i =0 ; $i -lt 10 ; $i++) { $current_value = $previous1_value + $previous2_value ; $previous2_value = $previous1_value ; $previous1_value = $current_value ; $current_value }

#OR

$previous2_value = 0
$previous1_value = 1
$previous2_value
$previous1_value

for ($i =0 ; $i -lt 10 ; $i++) { 
$current_value = $previous1_value + $previous2_value
$previous2_value = $previous1_value
$previous1_value = $current_value
$current_value 
}


#BUBBLE SORT
================================================================================

function Bubble_Sort($targetList) {
        $n = $targetList.Count

        for ($i = 0; $i -lt $n; $i+=1) {
            for ($j = 0; $j -lt $n-1; $j+=1) {
                if($targetList[$j] -gt $targetList[$j+1]) {
                    $temp = $targetList[$j+1]
                    $targetList[$j+1]=$targetList[$j]
                    $targetList[$j]=$temp
                }
            }
        }
		write-host ($targetList)
		return ($targetList)
    }


#QUICK SORT
================================================================================






#BINARY SEARCH
================================================================================







#MERGE TWO SORTED LISTS
================================================================================







#REVERSING A LINKED LIST
================================================================================
