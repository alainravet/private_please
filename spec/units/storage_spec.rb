require 'spec_helper'


describe PrivatePlease::Storage do

  let(:st)  { PrivatePlease::Storage.new }

  # instance methods
  let(:object_to_s)  {PrivatePlease::Candidate.for_instance_method(Object, 'to_s' )}
  let(:object_hash)  {PrivatePlease::Candidate.for_instance_method(Object, 'hash' )}
  # class methods
  let(:object_new )  {PrivatePlease::Candidate.for_class_method(Object, 'new'  )}

  context 'when empty' do
    it 'has no *candidates' do
      st.candidates_by_kind   .should == {:instance_methods=>{}, :class_methods=>{}}
      st.internal_calls       .should be_empty
      st.external_calls       .should be_empty
    end
  end

  example 'storing the 1st instance method candidate stores it so that it can be retrieved' do
    st.store_candidate(object_to_s)
    st.candidates_by_kind.should == {:instance_methods => {'Object' => Set.new('to_s')}, :class_methods=>{}}
    st.stored_candidate?(object_to_s).should be_true
  end

  example 'storing the 1st class method candidate stores it so that it can be retrieved' do
    st.store_candidate(object_new)
    st.stored_candidate?(object_new).should be_true
    st.candidates_by_kind.should == {:instance_methods => {}, :class_methods => {'Object' => Set.new('new')} }
  end

  example 'storing the 2nd instance method candidate stores it so that it can be retrieved' do
    st.store_candidate(object_to_s)
    st.store_candidate(object_hash)
    st.stored_candidate?(object_hash)    .should be_true
    st.candidates_by_kind.should == {:instance_methods => {'Object' => Set.new(%w(hash to_s))}, :class_methods=>{}}
  end


  example 'storing avoids duplication' do
    object_to_s = PrivatePlease::Candidate.for_instance_method(Object, 'to_s')
    st.store_candidate(object_to_s)
    st.store_candidate(object_to_s)   # duplication : ignore it
    st.candidates_by_kind.should == {:instance_methods => {'Object' => Set.new(%w(to_s))}, :class_methods=>{}}
  end

end
