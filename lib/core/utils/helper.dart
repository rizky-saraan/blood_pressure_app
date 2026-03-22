int rata(List<int> data) {
  return (data.reduce((a, b) => a + b) / data.length).round();
}
