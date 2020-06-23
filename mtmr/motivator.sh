# Define the motivations
# quotes.sh https://github.com/Toxblh/MTMR-presets/tree/master/metasean by @metasean
m[0]="hi qt! you’re doing great! 🌻"
m[1]="given your eyes a rest lately? 🐰"
m[2]="take another sip of water! 🐳"
m[3]="check your posture bb 💪"
m[4]="did you text mom yet today? 💛"
m[5]="wow, that is impressive work 👆"
m[6]="pet bruce! he deserves it! 🐱"
m[7]="get some fresh air soon 🌺"
m[8]="hey, do you need a snack? 🍎"
m[9]="owo that’s a powerful bitch 🎀"
m[10]="about time for a dance break 💃"

# Generate a random motivation
motivation_range=${#m[@]}            # length of motivation array
let "id=$RANDOM % $motivation_range" # select random integer in array’s range
printf "${m[$id]}"                   # return random