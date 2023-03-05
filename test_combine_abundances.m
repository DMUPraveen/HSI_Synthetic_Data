%this is just to test whether combine_abundaces work and to illustrate the
%use of the code and is not intended to be accurate hsi, (th abundances
%don't respect sum to one used in the example they are chosen so as to be
%able to easily test the code)

test_end_member1 = [1,2,3,4,5];
test_end_member2 = [1,1,1,1,1];
test_end_member3 = [5,4,3,2,1];

end_members = [test_end_member1;test_end_member2;test_end_member3];

abundance_1 = [1,2,3;4,5,6;7,8,9];
abundance_2 = [1,1,1;1,1,1;1,1,1];
abundance_3 = [1,0,1;0,0,0;0,1,0];

abundances = cat(3,abundance_1,abundance_2,abundance_3);

combined_data = combine_abundances(abundances,end_members);
