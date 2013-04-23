require 'spec_helper'


describe PrivatePlease::Store::CandidatesDB do

  let(:st)  { PrivatePlease::Store.new }
  let(:candidates_db)  { st.candidates_db }

  # instance methods
  let(:object_to_s)  {PrivatePlease::Candidate.for_instance_method(Object, 'to_s' )}
  let(:object_hash)  {PrivatePlease::Candidate.for_instance_method(Object, 'hash' )}
  # class methods
  let(:object_new )  {PrivatePlease::Candidate.for_class_method(Object, 'new'  )}

  context 'when fresh' do
    it 'is empty (has no candidates)' do
      candidates_db                 .should be_empty
      candidates_db.instance_methods.should be_empty
      candidates_db.class_methods   .should be_empty
    end
  end

  example 'storing the 1st instance method candidate stores it so that it can be retrieved' do
    candidates_db.store_candidate(object_to_s)

    candidates_db.stored_candidate?(object_to_s).should be_true
    candidates_db.instance_methods.should == {'Object' => PrivatePlease::MethodsNames.new('to_s')}
    candidates_db.class_methods   .should be_empty
  end

  example 'storing the 1st class method candidate stores it so that it can be retrieved' do
    candidates_db.store_candidate(object_new)

    candidates_db.stored_candidate?(object_new).should be_true
    candidates_db.instance_methods.should be_empty
    candidates_db.class_methods   .should == {'Object' => mnames_for('new')}
  end

  example 'storing the 2nd instance method candidate stores it so that it can be retrieved' do
    candidates_db.store_candidate(object_to_s)
    candidates_db.store_candidate(object_hash)

    candidates_db.stored_candidate?(object_hash).should be_true
    candidates_db.instance_methods.should == {'Object' => PrivatePlease::MethodsNames.new(%w(hash to_s))}
    candidates_db.class_methods   .should be_empty
  end

  example 'storing avoids duplication' do
    st.candidates_db.store_candidate(object_to_s)
    st.candidates_db.store_candidate(object_to_s) # duplication : ignore it

    candidates_db.instance_methods.should == {'Object' => PrivatePlease::MethodsNames.new(%w(to_s))}
    candidates_db.class_methods   .should be_empty
  end

end
