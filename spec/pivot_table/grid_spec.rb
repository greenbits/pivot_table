require 'spec_helper'

module PivotTable
  describe Grid do
    context 'accessors' do
      it { is_expected.to respond_to :source_data }
      it { is_expected.to respond_to :row_name }
      it { is_expected.to respond_to :column_name }
      it { is_expected.to respond_to :columns }
      it { is_expected.to respond_to :rows }
      it { is_expected.to respond_to :grand_total }
    end

    let(:d1) { build_data_object(1, 'r1', 'c1') }
    let(:d2) { build_data_object(2, 'r1', 'c2') }
    let(:d3) { build_data_object(3, 'r1', 'c3') }
    let(:d4) { build_data_object(4, 'r2', 'c1') }
    let(:d5) { build_data_object(5, 'r2', 'c2') }
    let(:d6) { build_data_object(6, 'r2', 'c3') }

    let(:sorted_data) { [d1, d2, d3, d4, d5, d6] }
    let(:unsorted_data) { [d6, d4, d5, d3, d2, d1] }

    let(:instance) do
      described_class.new(config) do |g|
        g.source_data = data
        g.row_name    = :row_name
        g.column_name = :column_name
        g.value_name  = :id
      end
    end

    context 'when data is already sorted' do
      let(:config) { {} }
      let(:data) { sorted_data }

      let(:column_headers) { %w(c1 c2 c3) }
      let(:row_headers) { %w(r1 r2) }
      let(:row_0) { [d1, d2, d3] }
      let(:row_1) { [d4, d5, d6] }
      let(:column_0) { [d1, d4] }
      let(:column_1) { [d2, d5] }
      let(:column_2) { [d3, d6] }
      let(:column_totals) { [d1.id + d4.id, d2.id + d5.id, d3.id + d6.id] }
      let(:row_totals) { [d1.id + d2.id + d3.id, d4.id + d5.id + d6.id] }
      let(:grand_total) { d1.id + d2.id + d3.id + d4.id + d5.id + d6.id }

      it_behaves_like 'a collection of columns'
      it_behaves_like 'a collection of rows'
      it_behaves_like 'a data grid'
    end

    context 'sorting unordered data' do
      let(:config) { { :sort => true } }
      let(:data) { unsorted_data }

      let(:column_headers) { %w(c1 c2 c3) }
      let(:row_headers) { %w(r1 r2) }
      let(:row_0) { [d1, d2, d3] }
      let(:row_1) { [d4, d5, d6] }
      let(:column_0) { [d1, d4] }
      let(:column_1) { [d2, d5] }
      let(:column_2) { [d3, d6] }
      let(:column_totals) { [d1.id + d4.id, d2.id + d5.id, d3.id + d6.id] }
      let(:row_totals) { [d1.id + d2.id + d3.id, d4.id + d5.id + d6.id] }
      let(:grand_total) { d1.id + d2.id + d3.id + d4.id + d5.id + d6.id }

      it_behaves_like 'a collection of columns'
      it_behaves_like 'a collection of rows'
      it_behaves_like 'a data grid'
    end

    context 'keep original data ordering' do
      let(:config) { { :sort => false } }
      let(:data) { unsorted_data }

      let(:column_headers) { %w(c3 c1 c2) }
      let(:row_headers) { %w(r2 r1) }
      let(:row_0) { [d6, d4, d5] }
      let(:row_1) { [d3, d1, d2] }
      let(:column_0) { [d6, d3] }
      let(:column_1) { [d4, d1] }
      let(:column_2) { [d5, d2] }
      let(:column_totals) { [d6.id + d3.id, d4.id + d1.id, d5.id + d2.id] }
      let(:row_totals) { [d6.id + d4.id + d5.id, d3.id + d2.id + d1.id] }
      let(:grand_total) { d1.id + d2.id + d3.id + d4.id + d5.id + d6.id }

      it_behaves_like 'a collection of columns'
      it_behaves_like 'a collection of rows'
      it_behaves_like 'a data grid'
    end

    context 'to_json' do
      let(:config) { { :sort => false } }
      let(:data) { unsorted_data }
      let(:expected_hash) do
        {
          column_name: 'column_name',
          row_name:    'row_name',
          value_name:  'id',
          source_data: data.map { |d| d.to_h }
        }
      end

      it 'should product the correct json' do
        expect(instance.to_json).to eq(expected_hash.to_json)
      end
    end
  end
end
