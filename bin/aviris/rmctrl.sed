    /usr/bin/mv $1 $$.tmp
#    echo "mv done"  
                   
    sed 's/^ ..//g' $$.tmp > $1
   
    /usr/bin/rm $$.tmp
#    echo "sed done"
    
