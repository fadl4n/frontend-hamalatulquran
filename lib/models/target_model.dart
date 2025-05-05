class TargetHafalan {
  final int id;
  final String namaSantri;
  final String kelas;
  final String pengajar;
  final String targetGroup;
  final String tglMulai;
  final String tglTarget;
  final String namaSurat;
  final int jumlahAyat;

  TargetHafalan({
    required this.id,
    required this.namaSantri,
    required this.kelas,
    required this.pengajar,
    required this.targetGroup,
    required this.tglMulai,
    required this.tglTarget,
    required this.namaSurat,
    required this.jumlahAyat,
  });

  factory TargetHafalan.fromJson(Map<String, dynamic> json) {
    return TargetHafalan(
      id: json['id_target'],
      namaSantri: json['nama_santri'],
      kelas: json['kelas'],
      pengajar: json['pengajar'],
      targetGroup: json['target_group'],
      tglMulai: json['tgl_mulai'],
      tglTarget: json['tgl_target'],
      namaSurat: json['nama_surat'],
      jumlahAyat: json['jumlah_ayat'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_target': id,
      'nama_santri': namaSantri,
      'kelas': kelas,
      'pengajar': pengajar,
      'target_group': targetGroup,
      'tgl_mulai': tglMulai,
      'tgl_target': tglTarget,
    };
  }
}