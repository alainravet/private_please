require 'spec_helper'


describe PrivatePlease::Storage::CandidatesStore do

  let(:st)  { PrivatePlease::Storage::Store.new }
  let(:candidates_store)  { st.candidates_store }

  # instance methods
  let(:object_to_s)  {PrivatePlease::Candidate.for_instance_method(Object, 'to_s' )}
  let(:object_hash)  {PrivatePlease::Candidate.for_instance_method(Object, 'hash' )}
  # class methods
  let(:object_new )  {PrivatePlease::Candidate.for_class_method(Object, 'new'  )}

  context 'when fresh' do
    it 'is empty (has no candidates)' do
      candidates_store                 .should be_empty
      candidates_store.instance_methods.should be_empty
      candidates_store.class_methods   .should be_empty
    end
  end

  example 'storing the 1st instance method candidate stores it so that it can be retrieved' do
    candidates_store.store(object_to_s)

    candidates_store.stored?(object_to_s).should be_true
    candidates_store.instance_methods.should == {'Object' => mnames_for('to_s')}
    candidates_store.class_methods   .should be_empty
  end

  example 'storing the 1st class method candidate stores it so that it can be retrieved' do
    candidates_store.store(object_new)

    candidates_store.stored?(object_new).should be_true
    candidates_store.instance_methods.should be_empty
    candidates_store.class_methods   .should == {'Object' => mnames_for('new')}
  end

  example 'storing the 2nd instance method candidate stores it so that it can be retrieved' do
    candidates_store.store(object_to_s)
    candidates_store.store(object_hash)

    candidates_store.stored?(object_hash).should be_true
    candidates_store.instance_methods.should == {'Object' => mnames_for(%w(hash to_s))}
    candidates_store.class_methods   .should be_empty
  end

  example 'storing avoids duplication' do
    st.candidates_store.store(object_to_s)
    st.candidates_store.store(object_to_s) # duplication : ignore it

    candidates_store.instance_methods.should == {'Object' => mnames_for(%w(to_s))}
    candidates_store.class_methods   .should be_empty
  end

end
