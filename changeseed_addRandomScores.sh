cp db/seeds.rb db/tempseeds.rb
cp db/ADDRandomScores.rb db/seeds.rb 
echo "//"
read justpausing_nothingtoseehere
rake db:seed
cp db/tempseeds.rb db/seeds.rb 