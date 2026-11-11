import 'package:flutter/material.dart';

import '../services/points_manager.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

/// Model representasi data analitik laporan mingguan
class WeeklyReportModel {
  final int weekNumber;
  final String dateRange; // misal '22 - 28 Okt 2026'
  final String shortRange; // misal '22 - 28 Okt'
  final String monthYear; // 'Okt 2026'
  final int totalUsage; // Liter
  final int dailyAverage; // L/hari
  final int savedLiters; // Liter vs standar 180L/hari
  final int savedRupiah; // Estimasi hemat biaya PDAM
  final String savingsPercent; // misal '-21% Sangat Hemat'
  final int streakDays;
  final int ecoPoints;
  final String reportId;
  final String categoryTitle; // 'KATEGORI A • ECO HERO'
  final String bestDay; // 'Kam'
  final int bestLiters; // 112
  final List<Map<String, dynamic>> dailyBars;
  final List<Map<String, dynamic>> activities;
  final String smartInsight;

  const WeeklyReportModel({
    required this.weekNumber,
    required this.dateRange,
    required this.shortRange,
    required this.monthYear,
    required this.totalUsage,
    required this.dailyAverage,
    required this.savedLiters,
    required this.savedRupiah,
    required this.savingsPercent,
    required this.streakDays,
    required this.ecoPoints,
    required this.reportId,
    required this.categoryTitle,
    required this.bestDay,
    required this.bestLiters,
    required this.dailyBars,
    required this.activities,
    required this.smartInsight,
  });
}

/// Model representasi data analitik laporan bulanan
class MonthlyReportModel {
  final String monthName; // 'Oktober 2026'
  final int totalUsage; // Liter
  final int dailyAverage; // L/hari
  final int savedLiters; // Liter vs standar 180L/hari
  final int savedRupiah; // Estimasi hemat biaya PDAM
  final String savingsPercent;
  final int streakDays;
  final int ecoPoints;
  final String reportId;
  final String categoryTitle;
  final String bestWeek; // 'Pekan 4'
  final int bestLiters; // 142
  final List<Map<String, dynamic>> weeklyBars;
  final List<Map<String, dynamic>> activities;
  final String smartInsight;

  const MonthlyReportModel({
    required this.monthName,
    required this.totalUsage,
    required this.dailyAverage,
    required this.savedLiters,
    required this.savedRupiah,
    required this.savingsPercent,
    required this.streakDays,
    required this.ecoPoints,
    required this.reportId,
    required this.categoryTitle,
    required this.bestWeek,
    required this.bestLiters,
    required this.weeklyBars,
    required this.activities,
    required this.smartInsight,
  });
}

/// Model representasi data analitik laporan harian
class DailyReportModel {
  final DateTime date;
  final String formattedDate; // 'Rabu, 28 Okt 2026'
  final String relativeLabel; // 'Hari Ini, 28 Okt 2026'
  final int totalUsage; // Liter
  final int dailyAverage; // Liter (sama dengan total harian)
  final int savedLiters; // Liter vs target 180L
  final int savedRupiah; // Rp
  final String savingsPercent;
  final int streakDays;
  final int ecoPoints;
  final String reportId;
  final String categoryTitle;
  final String bestTime; // 'Siang'
  final int bestLiters; // 28
  final List<Map<String, dynamic>> timeBars;
  final List<Map<String, dynamic>> activities;
  final String smartInsight;

  const DailyReportModel({
    required this.date,
    required this.formattedDate,
    required this.relativeLabel,
    required this.totalUsage,
    required this.dailyAverage,
    required this.savedLiters,
    required this.savedRupiah,
    required this.savingsPercent,
    required this.streakDays,
    required this.ecoPoints,
    required this.reportId,
    required this.categoryTitle,
    required this.bestTime,
    required this.bestLiters,
    required this.timeBars,
    required this.activities,
    required this.smartInsight,
  });
}

/// Halaman Laporan Konservasi Air (Water Conservation Report Screen)
/// Dirancang berbasis 8 Golden Rules of Interface Design & ramah masyarakat umum.
class LaporanKonservasiAirScreen extends StatefulWidget {
  const LaporanKonservasiAirScreen({super.key});

  @override
  State<LaporanKonservasiAirScreen> createState() =>
      _LaporanKonservasiAirScreenState();
}

class _LaporanKonservasiAirScreenState
    extends State<LaporanKonservasiAirScreen> {
  // ── State Tab Rentang Waktu: 0 = Hari, 1 = Minggu (Default), 2 = Bulan ──
  int _selectedPeriodType = 1;

  // ── State Index Pilihan Periode ──
  int _selectedWeekIndex = 3; // Index 0..3 (Minggu Ke-1 s/d Ke-4 Okt 2026)
  int _selectedMonthIndex = 2; // Index 0..3 (Agustus, September, Oktober, November 2026)
  int _selectedDayIndex = 3; // Index 0..3 (25, 26, 27, 28 Okt 2026)

  // Batas Efisiensi Target Pemakaian Harian (L/hari)
  static const int _targetLimit = 150;

  // ── DATA MOCK MINGGUAN (4 Minggu Berbeda di Oktober 2026) ──
  final List<WeeklyReportModel> _weeklyReports = [
    // Minggu Ke-1 (1 - 7 Okt 2026)
    const WeeklyReportModel(
      weekNumber: 1,
      dateRange: '1 - 7 Okt 2026',
      shortRange: '1 - 7 Okt',
      monthYear: 'Okt 2026',
      totalUsage: 1120, // 160 + 155 + 145 + 135 + 158 + 182 + 185 = 1120 L
      dailyAverage: 160, // 1120 / 7 = 160 L/hari
      savedLiters: 140, // 1260 - 1120 = 140 L
      savedRupiah: 9800,
      savingsPercent: '-11% Cukup Hemat',
      streakDays: 3,
      ecoPoints: 80,
      reportId: 'AQ-2026-W41-112',
      categoryTitle: 'KATEGORI B • KONSERVATOR AKTIF',
      bestDay: 'Kam',
      bestLiters: 135,
      dailyBars: [
        {'day': 'Sen', 'liters': 160},
        {'day': 'Sel', 'liters': 155},
        {'day': 'Rab', 'liters': 145},
        {'day': 'Kam', 'liters': 135},
        {'day': 'Jum', 'liters': 158},
        {'day': 'Sab', 'liters': 182},
        {'day': 'Min', 'liters': 185},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 78,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 28,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 21,
          'liters': 33,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 13,
          'liters': 21,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Mulai pasang aerator keran untuk menurunkan debit air cucian tanpa mengurangi kenyamanan kucuran.',
    ),

    // Minggu Ke-2 (8 - 14 Okt 2026)
    const WeeklyReportModel(
      weekNumber: 2,
      dateRange: '8 - 14 Okt 2026',
      shortRange: '8 - 14 Okt',
      monthYear: 'Okt 2026',
      totalUsage: 1071, // 152 + 146 + 138 + 130 + 150 + 175 + 180 = 1071 L
      dailyAverage: 153, // 1071 / 7 = 153 L/hari
      savedLiters: 189, // 1260 - 1071 = 189 L
      savedRupiah: 13200,
      savingsPercent: '-15% Hemat',
      streakDays: 6,
      ecoPoints: 95,
      reportId: 'AQ-2026-W42-107',
      categoryTitle: 'KATEGORI B • KONSERVATOR AKTIF',
      bestDay: 'Kam',
      bestLiters: 130,
      dailyBars: [
        {'day': 'Sen', 'liters': 152},
        {'day': 'Sel', 'liters': 146},
        {'day': 'Rab', 'liters': 138},
        {'day': 'Kam', 'liters': 130},
        {'day': 'Jum', 'liters': 150},
        {'day': 'Sab', 'liters': 175},
        {'day': 'Min', 'liters': 180},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 75,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 26,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 21,
          'liters': 32,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 13,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Penggunaan baskom saat mencuci piring memangkas pemborosan air keran mengalir sebesar 15 Liter.',
    ),

    // Minggu Ke-3 (15 - 21 Okt 2026)
    const WeeklyReportModel(
      weekNumber: 3,
      dateRange: '15 - 21 Okt 2026',
      shortRange: '15 - 21 Okt',
      monthYear: 'Okt 2026',
      totalUsage: 1030, // 148 + 140 + 132 + 125 + 145 + 168 + 172 = 1030 L
      dailyAverage: 147, // 1030 / 7 = 147 L/hari
      savedLiters: 230, // 1260 - 1030 = 230 L
      savedRupiah: 16100,
      savingsPercent: '-18% Sangat Hemat',
      streakDays: 9,
      ecoPoints: 110,
      reportId: 'AQ-2026-W43-103',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestDay: 'Kam',
      bestLiters: 125,
      dailyBars: [
        {'day': 'Sen', 'liters': 148},
        {'day': 'Sel', 'liters': 140},
        {'day': 'Rab', 'liters': 132},
        {'day': 'Kam', 'liters': 125},
        {'day': 'Jum', 'liters': 145},
        {'day': 'Sab', 'liters': 168},
        {'day': 'Min', 'liters': 172},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 48,
          'liters': 71,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 25,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 21,
          'liters': 31,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Perbaikan keran wastafel yang bocor berhasil menghemat hingga 18 Liter air per hari!',
    ),

    // Minggu Ke-4 (22 - 28 Okt 2026) - DEFAULT / TERBARU
    const WeeklyReportModel(
      weekNumber: 4,
      dateRange: '22 - 28 Okt 2026',
      shortRange: '22 - 28 Okt',
      monthYear: 'Okt 2026',
      totalUsage: 994, // 142 + 135 + 128 + 112 + 140 + 160 + 177 = 994 L
      dailyAverage: 142, // 994 / 7 = 142 L/hari
      savedLiters: 266, // 1260 - 994 = 266 L
      savedRupiah: 18500,
      savingsPercent: '-21% Sangat Hemat',
      streakDays: 12,
      ecoPoints: 120,
      reportId: 'AQ-2026-W44-994',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestDay: 'Kam',
      bestLiters: 112,
      dailyBars: [
        {'day': 'Sen', 'liters': 142},
        {'day': 'Sel', 'liters': 135},
        {'day': 'Rab', 'liters': 128},
        {'day': 'Kam', 'liters': 112},
        {'day': 'Jum', 'liters': 140},
        {'day': 'Sab', 'liters': 160},
        {'day': 'Min', 'liters': 177},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 69,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 24,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 28,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Mandi menyumbang efisiensi tertinggi minggu ini berkat pemangkasan durasi sebesar 2 menit!',
    ),
  ];

  // ── DATA MOCK BULANAN (Agustus, September, Oktober, November 2026) ──
  final List<MonthlyReportModel> _monthlyReports = [
    // Agustus 2026
    const MonthlyReportModel(
      monthName: 'Agustus 2026',
      totalUsage: 4676,
      dailyAverage: 156,
      savedLiters: 904,
      savedRupiah: 63200,
      savingsPercent: '-16% Hemat',
      streakDays: 8,
      ecoPoints: 290,
      reportId: 'AQ-2026-M08-467',
      categoryTitle: 'KATEGORI B • KONSERVATOR AKTIF',
      bestWeek: 'Pekan 4',
      bestLiters: 158,
      weeklyBars: [
        {'day': 'Pekan 1', 'liters': 175},
        {'day': 'Pekan 2', 'liters': 170},
        {'day': 'Pekan 3', 'liters': 165},
        {'day': 'Pekan 4', 'liters': 158},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 50,
          'liters': 78,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 27,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 31,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 13,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Tren penggunaan air bulanan mulai menunjukkan penurunan berkat pembiasaan mematikan keran saat cuci piring.',
    ),

    // September 2026
    const MonthlyReportModel(
      monthName: 'September 2026',
      totalUsage: 4445,
      dailyAverage: 148,
      savedLiters: 955,
      savedRupiah: 66800,
      savingsPercent: '-18% Sangat Hemat',
      streakDays: 10,
      ecoPoints: 350,
      reportId: 'AQ-2026-M09-444',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestWeek: 'Pekan 4',
      bestLiters: 150,
      weeklyBars: [
        {'day': 'Pekan 1', 'liters': 168},
        {'day': 'Pekan 2', 'liters': 162},
        {'day': 'Pekan 3', 'liters': 155},
        {'day': 'Pekan 4', 'liters': 150},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 73,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 25,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 30,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Penghematan konsisten terjadi di seluruh pekan dengan peningkatan kepatuhan batas target harian hingga 85%.',
    ),

    // Oktober 2026 (DEFAULT)
    const MonthlyReportModel(
      monthName: 'Oktober 2026',
      totalUsage: 4215, // Total 4 pekan pemantauan
      dailyAverage: 142,
      savedLiters: 1420, // Hemat Bulanan total
      savedRupiah: 99400,
      savingsPercent: '-25% Sangat Hemat',
      streakDays: 12,
      ecoPoints: 420,
      reportId: 'AQ-2026-M10-421',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestWeek: 'Pekan 4',
      bestLiters: 142,
      weeklyBars: [
        {'day': 'Pekan 1', 'liters': 160},
        {'day': 'Pekan 2', 'liters': 153},
        {'day': 'Pekan 3', 'liters': 147},
        {'day': 'Pekan 4', 'liters': 142},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 69,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 24,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 28,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Bulan terbaik sejauh ini! Penurunan rata-rata harian mencapai 14 L/hari dibanding bulan sebelumnya.',
    ),

    // November 2026
    const MonthlyReportModel(
      monthName: 'November 2026',
      totalUsage: 3801,
      dailyAverage: 135,
      savedLiters: 1239,
      savedRupiah: 86500,
      savingsPercent: '-28% Sangat Hemat',
      streakDays: 14,
      ecoPoints: 480,
      reportId: 'AQ-2026-M11-380',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestWeek: 'Pekan 4',
      bestLiters: 130,
      weeklyBars: [
        {'day': 'Pekan 1', 'liters': 138},
        {'day': 'Pekan 2', 'liters': 135},
        {'day': 'Pekan 3', 'liters': 140},
        {'day': 'Pekan 4', 'liters': 130},
      ],
      activities: [
        {
          'title': 'Mandi & Shower',
          'percent': 48,
          'liters': 65,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 23,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 21,
          'liters': 28,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 19,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Proyeksi penghematan sangat tinggi berkat kepatuhan konsisten dan penggunaan peralatan hemat air.',
    ),
  ];

  // ── DATA MOCK HARIAN (25, 26, 27, 28 Okt 2026) ──
  final List<DailyReportModel> _dailyReports = [
    // 25 Okt 2026
    DailyReportModel(
      date: DateTime(2026, 10, 25),
      formattedDate: 'Minggu, 25 Okt 2026',
      relativeLabel: '25 Okt 2026',
      totalUsage: 177,
      dailyAverage: 177,
      savedLiters: 3, // 180 - 177 = 3 L
      savedRupiah: 210,
      savingsPercent: '-2% Mendekati Batas',
      streakDays: 9,
      ecoPoints: 15,
      reportId: 'AQ-2026-D1025-177',
      categoryTitle: 'KATEGORI B • KONSERVATOR AKTIF',
      bestTime: 'Siang',
      bestLiters: 35,
      timeBars: const [
        {'day': 'Pagi', 'liters': 52},
        {'day': 'Siang', 'liters': 35},
        {'day': 'Sore', 'liters': 42},
        {'day': 'Malam', 'liters': 48},
      ],
      activities: const [
        {
          'title': 'Mandi & Shower',
          'percent': 50,
          'liters': 88,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 30,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 35,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 13,
          'liters': 24,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Aktivitas akhir pekan meningkatkan konsumsi air mandi dan mencuci pakaian.',
    ),

    // 26 Okt 2026
    DailyReportModel(
      date: DateTime(2026, 10, 26),
      formattedDate: 'Senin, 26 Okt 2026',
      relativeLabel: '26 Okt 2026',
      totalUsage: 142,
      dailyAverage: 142,
      savedLiters: 38, // 180 - 142 = 38 L
      savedRupiah: 2650,
      savingsPercent: '-21% Sangat Hemat',
      streakDays: 10,
      ecoPoints: 20,
      reportId: 'AQ-2026-D1026-142',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestTime: 'Siang',
      bestLiters: 28,
      timeBars: const [
        {'day': 'Pagi', 'liters': 42},
        {'day': 'Siang', 'liters': 28},
        {'day': 'Sore', 'liters': 32},
        {'day': 'Malam', 'liters': 40},
      ],
      activities: const [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 69,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 24,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 28,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Konsumsi air kembali di bawah batas efisiensi mandiri 150 L/hari.',
    ),

    // 27 Okt 2026
    DailyReportModel(
      date: DateTime(2026, 10, 27),
      formattedDate: 'Selasa, 27 Okt 2026',
      relativeLabel: 'Kemarin, 27 Okt 2026',
      totalUsage: 135,
      dailyAverage: 135,
      savedLiters: 45, // 180 - 135 = 45 L
      savedRupiah: 3150,
      savingsPercent: '-25% Sangat Hemat',
      streakDays: 11,
      ecoPoints: 25,
      reportId: 'AQ-2026-D1027-135',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestTime: 'Siang',
      bestLiters: 26,
      timeBars: const [
        {'day': 'Pagi', 'liters': 40},
        {'day': 'Siang', 'liters': 26},
        {'day': 'Sore', 'liters': 30},
        {'day': 'Malam', 'liters': 39},
      ],
      activities: const [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 66,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 23,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 27,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 19,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Efisiensi tinggi berkat mandi shower cepat 4 menit dan penampungan air wudhu.',
    ),

    // 28 Okt 2026 (DEFAULT / HARI INI)
    DailyReportModel(
      date: DateTime(2026, 10, 28),
      formattedDate: 'Rabu, 28 Okt 2026',
      relativeLabel: 'Hari Ini, 28 Okt 2026',
      totalUsage: 142, // 42 + 28 + 31 + 41 = 142 Liter
      dailyAverage: 142,
      savedLiters: 38, // 180 - 142 = 38 L
      savedRupiah: 2650,
      savingsPercent: '-21% Sangat Hemat',
      streakDays: 12,
      ecoPoints: 25,
      reportId: 'AQ-2026-D1028-142',
      categoryTitle: 'KATEGORI A • ECO HERO',
      bestTime: 'Siang',
      bestLiters: 28,
      timeBars: const [
        {'day': 'Pagi', 'liters': 42},
        {'day': 'Siang', 'liters': 28},
        {'day': 'Sore', 'liters': 31},
        {'day': 'Malam', 'liters': 41},
      ],
      activities: const [
        {
          'title': 'Mandi & Shower',
          'percent': 49,
          'liters': 69,
          'icon': Icons.shower_outlined,
          'color': Color(0xFF006296),
        },
        {
          'title': 'Sanitasi & Toilet',
          'percent': 17,
          'liters': 24,
          'icon': Icons.wc_rounded,
          'color': Color(0xFF0284C7),
        },
        {
          'title': 'Dapur & Masak',
          'percent': 20,
          'liters': 28,
          'icon': Icons.soup_kitchen_outlined,
          'color': Color(0xFF38BDF8),
        },
        {
          'title': 'Cuci Pakaian & Lainnya',
          'percent': 14,
          'liters': 20,
          'icon': Icons.local_laundry_service_outlined,
          'color': Color(0xFF94A3B8),
        },
      ],
      smartInsight:
          'Mandi menyumbang efisiensi tertinggi hari ini berkat pemangkasan durasi sebesar 2 menit!',
    ),
  ];

  // ── Helper Getters untuk Sinkronisasi Data Aktif ──
  WeeklyReportModel get _currentWeekly => _weeklyReports[_selectedWeekIndex];
  MonthlyReportModel get _currentMonthly =>
      _monthlyReports[_selectedMonthIndex];
  DailyReportModel get _currentDaily => _dailyReports[_selectedDayIndex];

  /// Label tab terpilih
  String get _periodTypeLabel {
    switch (_selectedPeriodType) {
      case 0:
        return 'Hari';
      case 2:
        return 'Bulan';
      default:
        return 'Minggu';
    }
  }

  /// Label grafik pemakaian
  String get _chartTitlePeriod {
    switch (_selectedPeriodType) {
      case 0:
        return 'Harian';
      case 2:
        return 'Bulanan';
      default:
        return 'Mingguan';
    }
  }

  /// Judul tampilan pada Bilah Pemilih Periode Tengah
  String get _periodSelectorTitle {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.relativeLabel;
      case 2:
        return _currentMonthly.monthName;
      default:
        return 'Minggu Ke-${_currentWeekly.weekNumber} • ${_currentWeekly.monthYear} (${_currentWeekly.shortRange})';
    }
  }

  /// Total pemakaian liter aktif
  int get _activeTotalUsage {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.totalUsage;
      case 2:
        return _currentMonthly.totalUsage;
      default:
        return _currentWeekly.totalUsage;
    }
  }

  /// Rata-rata harian liter aktif
  int get _activeDailyAverage {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.dailyAverage;
      case 2:
        return _currentMonthly.dailyAverage;
      default:
        return _currentWeekly.dailyAverage;
    }
  }

  /// Air diselamatkan / dihemat (Liter)
  int get _activeSavedLiters {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.savedLiters;
      case 2:
        return _currentMonthly.savedLiters;
      default:
        return _currentWeekly.savedLiters;
    }
  }

  /// Estimasi rupiah hemat
  int get _activeSavedRupiah {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.savedRupiah;
      case 2:
        return _currentMonthly.savedRupiah;
      default:
        return _currentWeekly.savedRupiah;
    }
  }

  /// Format Rupiah dengan pemisah ribuan
  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  /// Persentase hemat text
  String get _activeSavingsPercent {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.savingsPercent;
      case 2:
        return _currentMonthly.savingsPercent;
      default:
        return _currentWeekly.savingsPercent;
    }
  }

  /// Eco-Points aktif
  int get _activeEcoPoints {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.ecoPoints;
      case 2:
        return _currentMonthly.ecoPoints;
      default:
        return _currentWeekly.ecoPoints;
    }
  }

  /// Streak hari aktif
  int get _activeStreakDays {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.streakDays;
      case 2:
        return _currentMonthly.streakDays;
      default:
        return _currentWeekly.streakDays;
    }
  }

  /// Kategori predikat
  String get _activeCategoryTitle {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.categoryTitle;
      case 2:
        return _currentMonthly.categoryTitle;
      default:
        return _currentWeekly.categoryTitle;
    }
  }

  /// Batang grafik aktif
  List<Map<String, dynamic>> get _activeBars {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.timeBars;
      case 2:
        return _currentMonthly.weeklyBars;
      default:
        return _currentWeekly.dailyBars;
    }
  }

  /// Target garis acuan grafik
  double get _activeTargetLine {
    // Pada tampilan harian, target 150 L dibagi ke empat rentang waktu = 37.5 L
    return _selectedPeriodType == 0
        ? _targetLimit / 4.0
        : _targetLimit.toDouble();
  }

  /// Hari / Pekan / Jam paling hemat
  Map<String, dynamic> get _activeBestBar {
    return _activeBars.reduce(
      (a, b) => (a['liters'] as int) <= (b['liters'] as int) ? a : b,
    );
  }

  /// Daftar aktivitas konsumsi air aktif
  List<Map<String, dynamic>> get _activeActivities {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.activities;
      case 2:
        return _currentMonthly.activities;
      default:
        return _currentWeekly.activities;
    }
  }

  /// Wawasan cerdas aktif
  String get _activeSmartInsight {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.smartInsight;
      case 2:
        return _currentMonthly.smartInsight;
      default:
        return _currentWeekly.smartInsight;
    }
  }

  /// Report ID aktif
  String get _activeReportId {
    switch (_selectedPeriodType) {
      case 0:
        return _currentDaily.reportId;
      case 2:
        return _currentMonthly.reportId;
      default:
        return _currentWeekly.reportId;
    }
  }

  // ── Kontrol Navigasi Panah < > (Golden Rule #5 Prevent Errors) ──
  bool get _canGoPrevious {
    switch (_selectedPeriodType) {
      case 0:
        return _selectedDayIndex > 0;
      case 2:
        return _selectedMonthIndex > 0;
      default:
        return _selectedWeekIndex > 0;
    }
  }

  bool get _canGoNext {
    switch (_selectedPeriodType) {
      case 0:
        return _selectedDayIndex < _dailyReports.length - 1;
      case 2:
        return _selectedMonthIndex < _monthlyReports.length - 1;
      default:
        return _selectedWeekIndex < _weeklyReports.length - 1;
    }
  }

  void _onPreviousPeriod() {
    if (!_canGoPrevious) return;
    setState(() {
      switch (_selectedPeriodType) {
        case 0:
          _selectedDayIndex--;
          break;
        case 2:
          _selectedMonthIndex--;
          break;
        default:
          _selectedWeekIndex--;
          break;
      }
    });
  }

  void _onNextPeriod() {
    if (!_canGoNext) return;
    setState(() {
      switch (_selectedPeriodType) {
        case 0:
          _selectedDayIndex++;
          break;
        case 2:
          _selectedMonthIndex++;
          break;
        default:
          _selectedWeekIndex++;
          break;
      }
    });
  }

  // ─────────────────────────────────────────────────────────
  // BUILD METHOD UTAMA
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Segmented Tab Selector Satuan Waktu: Hari, Minggu, Bulan
                _buildSegmentedTimeTabs(),

                const SizedBox(height: 12),

                // 2. Bilah Pemilih Periode Interaktif (< Minggu Ke-4 >)
                _buildPeriodSelectorBar(),

                const SizedBox(height: 8),

                // 2b. Label Lingkup Pengguna Ramah Awam (Rumah / Kos Saya • Catatan Mandiri)
                _buildScopeMetadataBadge(),

                const SizedBox(height: 14),

                // 3. Hero Card Ringkasan Penghematan (Kartu Biru Terintegrasi Data)
                _buildHeroSavingsCard(),

                const SizedBox(height: 16),

                // 4. Grid 2x2 Metrik Cepat (Total Pemakaian, Air Diselamatkan, Eco-Points, Hemat Bulanan)
                _buildQuickStatsGrid(),

                const SizedBox(height: 18),

                // 5. Grafik Pemakaian Sesuai Periode (Sen s/d Min / Pagi s/d Malam / Pekan 1-4)
                _buildUsageChartCard(),

                const SizedBox(height: 18),

                // 6. Distribusi Berdasarkan Aktivitas (Angka liter & % utuh satu baris)
                _buildActivityDistributionCard(),

                const SizedBox(height: 18),

                // 7. Kartu Sertifikat Konservasi (Tombol Rapor di Bawah Lebar Penuh)
                _buildCertificateCard(),

                const SizedBox(height: 18),

                // 8. Banner Inspirasi Konservasi
                _buildInspirationBanner(),

                const SizedBox(height: 22),

                // 9. Tombol Aksi Bawah (Unduh Laporan, Bagikan Media Sosial, Tukar Poin)
                _buildBottomActionButtons(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. Top App Bar (Judul Singkat "Laporan Air" Anti-Terpotong)
  // ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF006296),
                  size: 18,
                ),
                SizedBox(width: 2),
                Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF006296),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        'Laporan Air',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        // Lencana Poin Reaktif (Kapsul Poin menuju Shop)
        const Center(child: EcoPointsPillWidget()),
        const SizedBox(width: 8),

        // Avatar Pengguna
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF006296),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. Segmented Button / Tab Selector (Hari, Minggu, Bulan)
  // Golden Rule #1: Consistency (Kata Benda Satuan Waktu)
  // ─────────────────────────────────────────────────────────
  Widget _buildSegmentedTimeTabs() {
    final periods = ['Hari', 'Minggu', 'Bulan'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriodType == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriodType = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF006296)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF006296)
                                .withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. Bilah Pemilih Periode Interaktif (Period Selector Bar)
  // Golden Rule #7: Internal Locus of Control & Rule #5: Prevent Errors
  // ─────────────────────────────────────────────────────────
  Widget _buildPeriodSelectorBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tombol Panah Mundur (<)
          IconButton(
            onPressed: _canGoPrevious ? _onPreviousPeriod : null,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: _canGoPrevious
                  ? const Color(0xFF006296)
                  : const Color(0xFFCBD5E1),
              size: 24,
            ),
            splashRadius: 20,
            tooltip: 'Periode Sebelumnya',
          ),

          // Tombol Pemilih Tengah (Bisa Diklik untuk Modal / DatePicker)
          Expanded(
            child: InkWell(
              onTap: _openPeriodPicker,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 6.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: Color(0xFF0284C7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _periodSelectorTitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Panah Maju (>)
          IconButton(
            onPressed: _canGoNext ? _onNextPeriod : null,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: _canGoNext
                  ? const Color(0xFF006296)
                  : const Color(0xFFCBD5E1),
              size: 24,
            ),
            splashRadius: 20,
            tooltip: 'Periode Berikutnya',
          ),
        ],
      ),
    );
  }

  /// Buka dialog/modal sesuai tab aktif
  void _openPeriodPicker() {
    switch (_selectedPeriodType) {
      case 0:
        _showDayPicker();
        break;
      case 2:
        _showMonthSelectorModal();
        break;
      default:
        _showWeekSelectorModal();
        break;
    }
  }

  /// DatePicker native untuk tab Hari
  Future<void> _showDayPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _currentDaily.date,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF006296),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Cari apakah ada data harian dengan tanggal tersebut
      final matchIndex = _dailyReports.indexWhere(
        (d) =>
            d.date.year == picked.year &&
            d.date.month == picked.month &&
            d.date.day == picked.day,
      );
      if (matchIndex != -1) {
        setState(() => _selectedDayIndex = matchIndex);
      } else {
        // Jika tanggal di luar 4 mock data, arahkan ke data terdekat
        setState(() => _selectedDayIndex = _dailyReports.length - 1);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Menampilkan data catatan harian terdekat: ${_currentDaily.formattedDate}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Modal Bottom Sheet Pemilih Minggu
  void _showWeekSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Minggu Pemantauan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bulan Oktober 2026 • 4 Periode Tersedia',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),
                ...List.generate(_weeklyReports.length, (idx) {
                  final item = _weeklyReports[idx];
                  final isCurrent = idx == _selectedWeekIndex;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedWeekIndex = idx);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFFF0F9FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? const Color(0xFF0284C7)
                              : const Color(0xFFE2E8F0),
                          width: isCurrent ? 1.4 : 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isCurrent
                                ? const Color(0xFF0284C7)
                                : const Color(0xFF94A3B8),
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minggu Ke-${item.weekNumber} (${item.dateRange})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isCurrent
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isCurrent
                                        ? const Color(0xFF006296)
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Total: ${item.totalUsage} L • Rata-rata: ${item.dailyAverage} L/hari',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _formatRupiah(item.savedRupiah),
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF006296),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Modal Bottom Sheet Pemilih Bulan
  void _showMonthSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Bulan Rekapitulasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tahun 2026 • Rekap Pemakaian Konservasi',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 14),
                ...List.generate(_monthlyReports.length, (idx) {
                  final item = _monthlyReports[idx];
                  final isCurrent = idx == _selectedMonthIndex;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedMonthIndex = idx);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFFF0F9FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? const Color(0xFF0284C7)
                              : const Color(0xFFE2E8F0),
                          width: isCurrent ? 1.4 : 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isCurrent
                                ? const Color(0xFF0284C7)
                                : const Color(0xFF94A3B8),
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.monthName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isCurrent
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isCurrent
                                        ? const Color(0xFF006296)
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Total: ${item.totalUsage} L • Rata-rata: ${item.dailyAverage} L/hari',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatRupiah(item.savedRupiah),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF006296),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2b. Label Lingkup Pengguna (Bahasa Ramah Umum)
  // "Rumah / Kos Saya • Catatan Mandiri"
  // ─────────────────────────────────────────────────────────
  Widget _buildScopeMetadataBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.home_outlined, size: 13, color: Color(0xFF006296)),
                  SizedBox(width: 4),
                  Text(
                    'Rumah / Kos Saya',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '•',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Catatan Mandiri',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
            SizedBox(width: 4),
            Text(
              'Tersinkronisasi',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 4. Hero Card Ringkasan Penghematan (Kartu Biru Terintegrasi Data)
  // Golden Rule #3: Offer Informative Feedback
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroSavingsCard() {
    final int savedLiters = _activeSavedLiters;
    final int avgDaily = _activeDailyAverage;
    final int diffStandard = 180 - avgDaily;
    final String diffText = diffStandard > 0
        ? '${diffStandard}L lebih hemat dari standar 180L'
        : 'Standar hemat 180L/hari';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF006296), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006296).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Badge Kategori + Streak Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          _activeCategoryTitle,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Streak Box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFDBA74),
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_activeStreakDays',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'Hari Streak',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Judul Utama & Subteks Penghematan
          const Text(
            'Penghematan Optimal!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rata-rata $avgDaily L/hari ($diffText).',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE0F2FE),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // 2 Metrik Pill: Air Dihemat & Hemat PDAM
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Air Dihemat',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBAE6FD),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              _selectedPeriodType == 1
                                  ? '$savedLiters L (7 hari)'
                                  : '$savedLiters L',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hemat PDAM',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBAE6FD),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              _formatRupiah(_activeSavedRupiah),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 5. Grid 2x2 Metrik Cepat (Total Pemakaian, Air Diselamatkan, dll)
  // ─────────────────────────────────────────────────────────
  Widget _buildQuickStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Pemakaian',
                value: '$_activeTotalUsage',
                unit: 'Liter',
                badgeText: _activeSavingsPercent,
                badgeColor: const Color(0xFF0284C7),
                badgeBg: const Color(0xFFE0F2FE),
                icon: Icons.water_damage_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Air Diselamatkan',
                value: '$_activeSavedLiters',
                unit: 'Liter',
                badgeText: _selectedPeriodType == 1
                    ? 'Setara 7 hari air minum keluarga.'
                    : 'Diselamatkan untuk kelestarian.',
                badgeColor: const Color(0xFF64748B),
                isSubtextOnly: true,
                icon: Icons.send_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Eco-Points',
                value: '+$_activeEcoPoints',
                unit: 'pts',
                badgeText: 'Saldo total: 850 pts',
                badgeColor: const Color(0xFF64748B),
                isSubtextOnly: true,
                icon: Icons.workspace_premium_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Hemat Bulanan',
                value: '1.420',
                unit: 'L',
                badgeText: '📈 +14% di atas target',
                badgeColor: const Color(0xFF0284C7),
                isSubtextOnly: true,
                icon: Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required String badgeText,
    required Color badgeColor,
    Color? badgeBg,
    bool isSubtextOnly = false,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF0284C7), size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isSubtextOnly)
            Text(
              badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badgeColor,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: badgeBg ?? const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: badgeColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 6. Grafik Pemakaian Sesuai Periode
  // ─────────────────────────────────────────────────────────
  Widget _buildUsageChartCard() {
    final bestBar = _activeBestBar;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul & Chip Hari/Pekan Paling Hemat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafik Pemakaian $_chartTitlePeriod',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedPeriodType == 0
                          ? 'Target rata-rata: 37,5 L per rentang waktu'
                          : 'Batas efisiensi mandiri: 150 L/hari',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.water_drop,
                      color: Color(0xFF0284C7),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${bestBar['day']}: ${bestBar['liters']}L (Paling Hemat)',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF006296),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Komponen Batang Grafik
          _buildCustomBarChart(),

          const SizedBox(height: 16),

          // Legenda Grafik (Di Bawah Batas Target vs Melebihi Target Harian)
          Row(
            children: [
              _buildLegendItem(
                color: const Color(0xFF0284C7),
                label: 'Di Bawah Batas Target',
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildLegendItem(
                  color: const Color(0xFF1E3A5F),
                  label: _selectedPeriodType == 0
                      ? 'Melebihi Target Waktu'
                      : 'Melebihi Target Harian (150 L)',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBarChart() {
    const double chartHeight = 160.0;
    final double maxLiters = _activeBars
        .map((bar) => (bar['liters'] as int).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final double scaleBase = maxLiters > _activeTargetLine
        ? maxLiters
        : _activeTargetLine;
    final double maxCapacity = ((scaleBase * 1.25 / 50).ceil() * 50).toDouble();
    final double targetLineBottom =
        chartHeight * (_activeTargetLine / maxCapacity);

    return SizedBox(
      height: chartHeight + 46,
      child: Stack(
        children: [
          // Garis horizontal putus-putus batas target
          Positioned(
            left: 0,
            right: 0,
            bottom: targetLineBottom + 26,
            child: Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints.constrainWidth();
                      const dashWidth = 5.0;
                      const dashSpace = 4.0;
                      final dashCount = (boxWidth / (dashWidth + dashSpace))
                          .floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return const SizedBox(
                            width: dashWidth,
                            height: 1.2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006296),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_activeTargetLine.toStringAsFixed(_selectedPeriodType == 0 ? 1 : 0)} L',
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Batang Grafik Pemakaian
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _activeBars.map((bar) {
                final int liters = bar['liters'] as int;
                final bool exceeds = liters > _activeTargetLine;
                final bool isBest =
                    liters == (_activeBestBar['liters'] as int);
                final String day = bar['day'] as String;

                final double barH = (liters / maxCapacity) * chartHeight;
                final Color barColor = exceeds
                    ? const Color(0xFF1E3A5F) // Navy tua untuk melebihi target
                    : const Color(0xFF0284C7); // Biru cyan untuk hemat

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Angka Liter di Atas Batang
                        Text(
                          '$liters',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isBest
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: isBest
                                ? const Color(0xFF0284C7)
                                : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Batang Visual
                        Container(
                          height: barH,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: barColor.withValues(alpha: 0.22),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Nama Periode di Bawah Batang
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isBest
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: isBest
                                ? const Color(0xFF006296)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 7. Distribusi Berdasarkan Aktivitas
  // Angka liter dan persentase utuh satu baris anti-terpotong
  // ─────────────────────────────────────────────────────────
  Widget _buildActivityDistributionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Aktivitas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Distribusi Berdasarkan Aktivitas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.pie_chart_outline_rounded,
                color: Color(0xFF006296),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Rata-rata $_activeDailyAverage Liter / hari',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 16),

          // Daftar 4 Aktivitas Utama
          ..._activeActivities.map((item) {
            final String title = item['title'] as String;
            final int percent = item['percent'] as int;
            final int liters = item['liters'] as int;
            final IconData icon = item['icon'] as IconData;
            final Color barColor = item['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          size: 15,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Teks persentase dan liter berada dalam satu baris utuh
                      Text(
                        '$percent% ($liters L)',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent / 100.0,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          // Kotak Wawasan Cerdas
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF0284C7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Wawasan Cerdas: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF006296),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: _activeSmartInsight,
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 8. Kartu Sertifikat Konservasi (Tombol Rapor di Posisi Bawah Full-Width)
  // ─────────────────────────────────────────────────────────
  Widget _buildCertificateCard() {
    final String certSubtitle = _selectedPeriodType == 1
        ? 'Sertifikat Konservasi Minggu Ke-${_currentWeekly.weekNumber}'
        : (_selectedPeriodType == 2
            ? 'Sertifikat Konservasi ${_currentMonthly.monthName}'
            : 'Sertifikat Konservasi Harian (${_currentDaily.relativeLabel})');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ikon Penghargaan + Misi + Judul
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFF0284C7),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Misi Hemat Air Bersih',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0284C7),
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Efisiensi Air',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      certSubtitle,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Teks Keterangan Sertifikat
          const Text(
            'Selamat! Kamu memenuhi seluruh kriteria kelestarian lingkungan periode ini. Rapor lengkap siap diverifikasi.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // 2 Kotak Status Evaluasi & Estimasi Hemat Biaya
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.shield_outlined,
                            color: Color(0xFF0284C7),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Status Evaluasi',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _activeCategoryTitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF006296),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.savings_outlined,
                            color: Color(0xFF0284C7),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Estimasi Hemat Biaya',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatRupiah(_activeSavedRupiah),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Baris Identitas Nama & ID Sertifikat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF0284C7),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Farhan Pratama',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    'ID: $_activeReportId',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Tombol Buka Rapor Penuh (Full-Width) di Posisi Bawah
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _showDetailedReportModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006296),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Buka Rapor Konservasi Lengkap',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 9. Banner Inspirasi Konservasi
  // ─────────────────────────────────────────────────────────
  Widget _buildInspirationBanner() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/kampus_hijau.jpg',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: const Color(0xFF065F46),
                        child: const Center(
                          child: Icon(
                            Icons.eco_rounded,
                            size: 44,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 12,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Inspirasi Konservasi',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Menjaga Sumber Mata Air Masa Depan',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _showArticleModal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Baca 3 langkah mudah instalasi aerator kran.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      Text(
                        'Baca >',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 10. Tombol Aksi Bawah
  // ─────────────────────────────────────────────────────────
  Widget _buildBottomActionButtons() {
    return Column(
      children: [
        // Tombol 1: Unduh Laporan Hemat Air (PDF)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF006296),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Unduh Ringkasan Laporan (PDF) berhasil disimpan ke memori perangkat!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Unduh Laporan Hemat Air (PDF)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006296),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tombol 2: Bagikan Pencapaian ke Media Sosial
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _showSharePreviewModal,
            icon: const Icon(
              Icons.share_outlined,
              color: Color(0xFF0284C7),
              size: 19,
            ),
            label: const Text(
              'Bagikan Pencapaian ke Media Sosial',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0284C7),
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF0F9FF),
              side: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tombol 3: Tukar Poin Konservasi di Shop
        AnimatedBuilder(
          animation: EcoPointsManager(),
          builder: (context, _) {
            final pts = EcoPointsManager().points;
            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.card_giftcard_rounded,
                    color: Color(0xFF0284C7),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Tukar Poin Konservasi di Shop ($pts pts)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Rapor Lengkap
  // ─────────────────────────────────────────────────────────
  void _showDetailedReportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF0284C7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rapor Konservasi $_periodTypeLabel',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '$_periodSelectorTitle • ID: $_activeReportId',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                _buildRaporDetailRow(
                  'Total Konsumsi Air:',
                  '$_activeTotalUsage Liter',
                ),
                _buildRaporDetailRow(
                  'Rata-rata Harian:',
                  '$_activeDailyAverage L/hari (Target 150 L)',
                ),
                _buildRaporDetailRow(
                  'Efisiensi vs Normal:',
                  '$_activeSavedLiters L Dihemat (Standar 180L)',
                ),
                _buildRaporDetailRow(
                  'Estimasi Hemat Tagihan Air:',
                  _formatRupiah(_activeSavedRupiah),
                ),
                _buildRaporDetailRow(
                  'Status Predikat:',
                  _activeCategoryTitle,
                ),
                _buildRaporDetailRow(
                  'Kepatuhan Target SDG 6.4:',
                  '100% Memenuhi Standar',
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Tutup Rapor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRaporDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Artikel
  // ─────────────────────────────────────────────────────────
  void _showArticleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '3 Langkah Mudah Instalasi Aerator Kran',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Buka saringan kran lama menggunakan kunci pas atau tangan.\n'
                  '2. Pasang aerator hemat air bertipe swirl flow yang mampu mengurangi debit hingga 40% tanpa menurunkan tekanan rasa semprotan.\n'
                  '3. Kencangkan dan uji alirannya. Kamu telah menghemat rata-rata 6 Liter air per menit!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006296),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Selesai Membaca',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Modal Mode Pratinjau Bagikan (Sertifikat Resmi UN SDG 6 Edition)
  // ─────────────────────────────────────────────────────────
  void _showSharePreviewModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Mode Pratinjau Bagikan',
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.94),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, anim1, anim2) {
        final currentPoints = EcoPointsManager().points;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Mode Pratinjau Bagikan + Tombol Silang
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Mode Pratinjau Bagikan',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Kartu Sertifikat Konservasi
                      _buildShareCertificateCard(currentPoints),

                      const SizedBox(height: 16),

                      // Tombol Utama: Simpan Gambar
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF06B6D4), Color(0xFF0D9488)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF06B6D4)
                                  .withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF0D9488),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Row(
                                    children: const [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Gambar sertifikat disimpan ke Galeri! Siap dibagikan ke Media Sosial 💧📸',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Simpan Gambar (Siap Bagikan)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Baris 2 Tombol: Salin Ringkasan & Tutup
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF006296),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      content: const Text(
                                        'Ringkasan pencapaian konservasi disalin ke clipboard! 📋💧',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                label: const Text(
                                  'Salin Ringkasan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E293B),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E293B),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Tutup',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.94,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
            child: child,
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // Widget Kartu Sertifikat Resmi (Mode Pratinjau Bagikan)
  // ─────────────────────────────────────────────────────────
  Widget _buildShareCertificateCard(int currentPoints) {
    final String certSubtitle = _selectedPeriodType == 1
        ? 'Sertifikat Dampak Konservasi Air • Minggu Ke-${_currentWeekly.weekNumber}'
        : (_selectedPeriodType == 2
            ? 'Sertifikat Dampak Konservasi Air • ${_currentMonthly.monthName}'
            : 'Sertifikat Dampak Konservasi Air • ${_currentDaily.formattedDate}');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Kartu: Logo AquaGuard & OFFICIAL SDG 6 Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/aquaguard_logo.png',
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.water_drop,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'AquaGuard',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'UN SDG 6 EDITION',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0284C7),
                                    letterSpacing: 0.6,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF86EFAC),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF16A34A),
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'OFFICIAL SDG 6',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF15803D),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 2. Subtitle: Sertifikat Dampak Konservasi Air
                Row(
                  children: [
                    const Icon(Icons.circle, size: 5, color: Color(0xFF0284C7)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        certSubtitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 3. User Identity Box: Farhan Pratama (Verified)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Color(0xFF006296),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 9,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Nelvin C.',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Text(
                              'Pelopor Konservasi • Rumah / Kos Saya',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              '🎉 Pahlawan Hemat Air Periode Ini!',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 4. Hero Card: TOTAL AIR DIHEMAT
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFBAE6FD),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TOTAL AIR DIHEMAT PERIODE INI',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        '245 Liter',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF006296),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBAE6FD),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              size: 13,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                '≈ Setara ${(_activeSavedLiters / 20).round()} Hari Kebutuhan Air Minum Bersih',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF006296),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 5. Grid 4 Metrik
                Row(
                  children: [
                    // Kartu 1: Eco-Points
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                  child: Text(
                                    'Eco-Points',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.eco_rounded,
                                  size: 12,
                                  color: Color(0xFF10B981),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '$currentPoints',
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+$_activeEcoPoints pts',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Kartu 2: Streak Aktif
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                  child: Text(
                                    'Streak Aktif',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 12,
                                  color: Color(0xFFEA580C),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '$_activeStreakDays Hari',
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Terjaga',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEA580C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    // Kartu 3: Hemat PDAM
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                  child: Text(
                                    'Hemat PDAM',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.savings_outlined,
                                  size: 12,
                                  color: Color(0xFFD97706),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _formatRupiah(_activeSavedRupiah),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Kartu 4: Peringkat Komunitas
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                  child: Text(
                                    'Peringkat Warga',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 12,
                                  color: Color(0xFFEAB308),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: const [
                                  Text(
                                    'Top 5%',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Komunitas',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 6. Garis Pembatas Tiket Perforasi
                _buildTicketDivider(),

                const SizedBox(height: 14),

                // 7. Footer Sertifikat: QR Code & Nomor Sertifikat + Target SDG 6.4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NOMOR SERTIFIKAT',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const Text(
                              'AG-2026-MKS-899',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                fontFamily: 'monospace',
                              ),
                            ),
                            const Text(
                              '✓ Tervalidasi Otomatis',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.track_changes_rounded,
                            color: Color(0xFFEF4444),
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Target SDG 6.4',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF006296),
                                  ),
                                ),
                                Text(
                                  '"Setiap tetes diperhitungkan untuk masa depan."',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF64748B),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Garis pembatas tiket perforasi dengan cutout notch
  Widget _buildTicketDivider() {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-24, 0),
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 5.0;
              const dashSpace = 4.0;
              final count =
                  (constraints.maxWidth / (dashWidth + dashSpace)).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(count, (_) {
                  return const SizedBox(
                    width: dashWidth,
                    height: 1.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFCBD5E1)),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        Transform.translate(
          offset: const Offset(24, 0),
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
