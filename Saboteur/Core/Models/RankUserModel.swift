struct RankUser: Codable, Identifiable {
  var id: String { uid }
  let uid: String
  let name: String
  let photoUrl: String?
  let points: Int
}
