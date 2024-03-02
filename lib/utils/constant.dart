import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnus_app/utils/userModel.dart';

import 'countries.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double wid(BuildContext context) {
  return width(context) * 0.9;
}

bool isToggle = false;
bool isPremium = false;
bool isPosition = false;

Color lightYellow = Color.fromRGBO(255, 220, 8, 1);
Color darkYellow = const Color.fromRGBO(255, 146, 9, 1);
Color ligyellow = Color.fromRGBO(255, 195, 0, 1);
Color yellow = Color.fromRGBO(254, 173, 29, 1);
Color boxBgColor = const Color.fromRGBO(51, 51, 51, 1);
Color white = Colors.white;
Color blackLight = Color.fromRGBO(50, 50, 50, 1);
Color black = Colors.black;

List freeCourseDetails = [];
List<dynamic> freeCourseLectureList = [[]];
List premiumCourseDetails = [];
List<dynamic> premiumCourseLectureList = [[]];

Users users = Users(
    uid: "",
    fullName: "",
    email: "",
    city: "",
    country: "",
    mobNum: "",
    invitationId: "",
    isPremium: false,
    freeCourses: [],
    purchasedCourses: [],
    videosWatched: [],
    pass: '',
    dob: '',
    gender: '',
    profileImage: '',
    premiumTill: '',
    displayName: "",
    id: "",
    joiningDate: "");

// only gradient
Gradient yellowLinerGradient() {
  return LinearGradient(
    colors: [lightYellow, darkYellow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

Gradient whiteLinerGradient() {
  return const LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// Gradient decorations
BoxDecoration gradientBoxDecoration(Gradient gradient, double radius) {
  return BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with border colors only
BoxDecoration myOutlineBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with fill box colors
BoxDecoration myFillBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

TextStyle bodyText14w600({required Color color}) {
  return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText12w600({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText14normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText12normal({required Color color}) {
  return TextStyle(
    fontSize: 12,
    color: color,
  );
}

TextStyle bodyText13normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText16w600({required Color color}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w700);
}

// small Size
TextStyle bodyText12Small({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodytext12Bold({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText20w700({required Color color}) {
  return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
}

TextStyle bodyText16w700({required Color color}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold);
}

TextStyle bodyText24W600({required Color color}) {
  return TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.w700);
}

TextStyle bodyText28W600({required Color color}) {
  return TextStyle(fontSize: 26, color: color, fontWeight: FontWeight.w700);
}

// box decoration with Boxshadow
BoxDecoration shadowDecoration() {
  return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(11)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
        ),
      ]);
}

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalySpace(double width) {
  return SizedBox(width: width);
}
// const kTextFieldDecoration = InputDecoration(
//   prefix: Text(
//     '    +91  ',
//     style: TextStyle(color: Colors.white, fontSize: 18),
//   ),
//   contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 1.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 2.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
// );

List premiumPlan = [
  {
    'title': 'Basic',
    'original price': '',
    'discPrice': 'Rs.5000',
    'usd': '(USD 90)'
  },
  {
    'title': 'Advance',
    'original price': '',
    'discPrice': 'Rs.15000',
    'usd': '(USD 245)'
  },
  {
    'title': 'Pro-Trader',
    'original price': '',
    'discPrice': 'Rs.25000',
    'usd': '(USD 405)'
  }
];

List<String> listCountries = [];

List<Countries> countriesList = [
  Countries(name: 'Afghanistan', code: 'AF'),
  Countries(name: 'Åland Islands', code: 'AX'),
  Countries(name: 'Albania', code: 'AL'),
  Countries(name: 'Algeria', code: 'DZ'),
  Countries(name: 'American Samoa', code: 'AS'),
  Countries(name: 'AndorrA', code: 'AD'),
  Countries(name: 'Angola', code: 'AO'),
  Countries(name: 'Anguilla', code: 'AI'),
  Countries(name: 'Antarctica', code: 'AQ'),
  Countries(name: 'Antigua and Barbuda', code: 'AG'),
  Countries(name: 'Argentina', code: 'AR'),
  Countries(name: 'Armenia', code: 'AM'),
  Countries(name: 'Aruba', code: 'AW'),
  Countries(name: 'Australia', code: 'AU'),
  Countries(name: 'Austria', code: 'AT'),
  Countries(name: 'Azerbaijan', code: 'AZ'),
  Countries(name: 'Bahamas', code: 'BS'),
  Countries(name: 'Bahrain', code: 'BH'),
  Countries(name: 'Bangladesh', code: 'BD'),
  Countries(name: 'Barbados', code: 'BB'),
  Countries(name: 'Belarus', code: 'BY'),
  Countries(name: 'Belgium', code: 'BE'),
  Countries(name: 'Belize', code: 'BZ'),
  Countries(name: 'Benin', code: 'BJ'),
  Countries(name: 'Bermuda', code: 'BM'),
  Countries(name: 'Bhutan', code: 'BT'),
  Countries(name: 'Bolivia', code: 'BO'),
  Countries(name: 'Bosnia and Herzegovina', code: 'BA'),
  Countries(name: 'Botswana', code: 'BW'),
  Countries(name: 'Bouvet Island', code: 'BV'),
  Countries(name: 'Brazil', code: 'BR'),
  Countries(name: 'British Indian Ocean Territory', code: 'IO'),
  Countries(name: 'Brunei Darussalam', code: 'BN'),
  Countries(name: 'Bulgaria', code: 'BG'),
  Countries(name: 'Burkina Faso', code: 'BF'),
  Countries(name: 'Burundi', code: 'BI'),
  Countries(name: 'Cambodia', code: 'KH'),
  Countries(name: 'Cameroon', code: 'CM'),
  Countries(name: 'Canada', code: 'CA'),
  Countries(name: 'Cape Verde', code: 'CV'),
  Countries(name: 'Cayman Islands', code: 'KY'),
  Countries(name: 'Central African Republic', code: 'CF'),
  Countries(name: 'Chad', code: 'TD'),
  Countries(name: 'Chile', code: 'CL'),
  Countries(name: 'China', code: 'CN'),
  Countries(name: 'Christmas Island', code: 'CX'),
  Countries(name: 'Cocos (Keeling) Islands', code: 'CC'),
  Countries(name: 'Colombia', code: 'CO'),
  Countries(name: 'Comoros', code: 'KM'),
  Countries(name: 'Congo', code: 'CG'),
  Countries(name: 'Congo, The Democratic Republic of the', code: 'CD'),
  Countries(name: 'Cook Islands', code: 'CK'),
  Countries(name: 'Costa Rica', code: 'CR'),
  Countries(name: 'Cote D\'Ivoire', code: 'CI'),
  Countries(name: 'Croatia', code: 'HR'),
  Countries(name: 'Cuba', code: 'CU'),
  Countries(name: 'Cyprus', code: 'CY'),
  Countries(name: 'Czech Republic', code: 'CZ'),
  Countries(name: 'Denmark', code: 'DK'),
  Countries(name: 'Djibouti', code: 'DJ'),
  Countries(name: 'Dominica', code: 'DM'),
  Countries(name: 'Dominican Republic', code: 'DO'),
  Countries(name: 'Ecuador', code: 'EC'),
  Countries(name: 'Egypt', code: 'EG'),
  Countries(name: 'El Salvador', code: 'SV'),
  Countries(name: 'Equatorial Guinea', code: 'GQ'),
  Countries(name: 'Eritrea', code: 'ER'),
  Countries(name: 'Estonia', code: 'EE'),
  Countries(name: 'Ethiopia', code: 'ET'),
  Countries(name: 'Falkland Islands (Malvinas)', code: 'FK'),
  Countries(name: 'Faroe Islands', code: 'FO'),
  Countries(name: 'Fiji', code: 'FJ'),
  Countries(name: 'Finland', code: 'FI'),
  Countries(name: 'France', code: 'FR'),
  Countries(name: 'French Guiana', code: 'GF'),
  Countries(name: 'French Polynesia', code: 'PF'),
  Countries(name: 'French Southern Territories', code: 'TF'),
  Countries(name: 'Gabon', code: 'GA'),
  Countries(name: 'Gambia', code: 'GM'),
  Countries(name: 'Georgia', code: 'GE'),
  Countries(name: 'Germany', code: 'DE'),
  Countries(name: 'Ghana', code: 'GH'),
  Countries(name: 'Gibraltar', code: 'GI'),
  Countries(name: 'Greece', code: 'GR'),
  Countries(name: 'Greenland', code: 'GL'),
  Countries(name: 'Grenada', code: 'GD'),
  Countries(name: 'Guadeloupe', code: 'GP'),
  Countries(name: 'Guam', code: 'GU'),
  Countries(name: 'Guatemala', code: 'GT'),
  Countries(name: 'Guernsey', code: 'GG'),
  Countries(name: 'Guinea', code: 'GN'),
  Countries(name: 'Guinea-Bissau', code: 'GW'),
  Countries(name: 'Guyana', code: 'GY'),
  Countries(name: 'Haiti', code: 'HT'),
  Countries(name: 'Heard Island and Mcdonald Islands', code: 'HM'),
  Countries(name: 'Holy See (Vatican City State)', code: 'VA'),
  Countries(name: 'Honduras', code: 'HN'),
  Countries(name: 'Hong Kong', code: 'HK'),
  Countries(name: 'Hungary', code: 'HU'),
  Countries(name: 'Iceland', code: 'IS'),
  Countries(name: 'India', code: 'IN'),
  Countries(name: 'Indonesia', code: 'ID'),
  Countries(name: 'Iran, Islamic Republic Of', code: 'IR'),
  Countries(name: 'Iraq', code: 'IQ'),
  Countries(name: 'Ireland', code: 'IE'),
  Countries(name: 'Isle of Man', code: 'IM'),
  Countries(name: 'Israel', code: 'IL'),
  Countries(name: 'Italy', code: 'IT'),
  Countries(name: 'Jamaica', code: 'JM'),
  Countries(name: 'Japan', code: 'JP'),
  Countries(name: 'Jersey', code: 'JE'),
  Countries(name: 'Jordan', code: 'JO'),
  Countries(name: 'Kazakhstan', code: 'KZ'),
  Countries(name: 'Kenya', code: 'KE'),
  Countries(name: 'Kiribati', code: 'KI'),
  Countries(name: 'Korea, Democratic People\'S Republic of', code: 'KP'),
  Countries(name: 'Korea, Republic of', code: 'KR'),
  Countries(name: 'Kuwait', code: 'KW'),
  Countries(name: 'Kyrgyzstan', code: 'KG'),
  Countries(name: 'Lao People\'S Democratic Republic', code: 'LA'),
  Countries(name: 'Latvia', code: 'LV'),
  Countries(name: 'Lebanon', code: 'LB'),
  Countries(name: 'Lesotho', code: 'LS'),
  Countries(name: 'Liberia', code: 'LR'),
  Countries(name: 'Libyan Arab Jamahiriya', code: 'LY'),
  Countries(name: 'Liechtenstein', code: 'LI'),
  Countries(name: 'Lithuania', code: 'LT'),
  Countries(name: 'Luxembourg', code: 'LU'),
  Countries(name: 'Macao', code: 'MO'),
  Countries(name: 'Macedonia, The Former Yugoslav Republic of', code: 'MK'),
  Countries(name: 'Madagascar', code: 'MG'),
  Countries(name: 'Malawi', code: 'MW'),
  Countries(name: 'Malaysia', code: 'MY'),
  Countries(name: 'Maldives', code: 'MV'),
  Countries(name: 'Mali', code: 'ML'),
  Countries(name: 'Malta', code: 'MT'),
  Countries(name: 'Marshall Islands', code: 'MH'),
  Countries(name: 'Martinique', code: 'MQ'),
  Countries(name: 'Mauritania', code: 'MR'),
  Countries(name: 'Mauritius', code: 'MU'),
  Countries(name: 'Mayotte', code: 'YT'),
  Countries(name: 'Mexico', code: 'MX'),
  Countries(name: 'Micronesia, Federated States of', code: 'FM'),
  Countries(name: 'Moldova, Republic of', code: 'MD'),
  Countries(name: 'Monaco', code: 'MC'),
  Countries(name: 'Mongolia', code: 'MN'),
  Countries(name: 'Montserrat', code: 'MS'),
  Countries(name: 'Morocco', code: 'MA'),
  Countries(name: 'Mozambique', code: 'MZ'),
  Countries(name: 'Myanmar', code: 'MM'),
  Countries(name: 'Namibia', code: 'NA'),
  Countries(name: 'Nauru', code: 'NR'),
  Countries(name: 'Nepal', code: 'NP'),
  Countries(name: 'Netherlands', code: 'NL'),
  Countries(name: 'Netherlands Antilles', code: 'AN'),
  Countries(name: 'New Caledonia', code: 'NC'),
  Countries(name: 'New Zealand', code: 'NZ'),
  Countries(name: 'Nicaragua', code: 'NI'),
  Countries(name: 'Niger', code: 'NE'),
  Countries(name: 'Nigeria', code: 'NG'),
  Countries(name: 'Niue', code: 'NU'),
  Countries(name: 'Norfolk Island', code: 'NF'),
  Countries(name: 'Northern Mariana Islands', code: 'MP'),
  Countries(name: 'Norway', code: 'NO'),
  Countries(name: 'Oman', code: 'OM'),
  Countries(name: 'Pakistan', code: 'PK'),
  Countries(name: 'Palau', code: 'PW'),
  Countries(name: 'Palestinian Territory, Occupied', code: 'PS'),
  Countries(name: 'Panama', code: 'PA'),
  Countries(name: 'Papua New Guinea', code: 'PG'),
  Countries(name: 'Paraguay', code: 'PY'),
  Countries(name: 'Peru', code: 'PE'),
  Countries(name: 'Philippines', code: 'PH'),
  Countries(name: 'Pitcairn', code: 'PN'),
  Countries(name: 'Poland', code: 'PL'),
  Countries(name: 'Portugal', code: 'PT'),
  Countries(name: 'Puerto Rico', code: 'PR'),
  Countries(name: 'Qatar', code: 'QA'),
  Countries(name: 'Reunion', code: 'RE'),
  Countries(name: 'Romania', code: 'RO'),
  Countries(name: 'Russian Federation', code: 'RU'),
  Countries(name: 'RWANDA', code: 'RW'),
  Countries(name: 'Saint Helena', code: 'SH'),
  Countries(name: 'Saint Kitts and Nevis', code: 'KN'),
  Countries(name: 'Saint Lucia', code: 'LC'),
  Countries(name: 'Saint Pierre and Miquelon', code: 'PM'),
  Countries(name: 'Saint Vincent and the Grenadines', code: 'VC'),
  Countries(name: 'Samoa', code: 'WS'),
  Countries(name: 'San Marino', code: 'SM'),
  Countries(name: 'Sao Tome and Principe', code: 'ST'),
  Countries(name: 'Saudi Arabia', code: 'SA'),
  Countries(name: 'Senegal', code: 'SN'),
  Countries(name: 'Serbia and Montenegro', code: 'CS'),
  Countries(name: 'Seychelles', code: 'SC'),
  Countries(name: 'Sierra Leone', code: 'SL'),
  Countries(name: 'Singapore', code: 'SG'),
  Countries(name: 'Slovakia', code: 'SK'),
  Countries(name: 'Slovenia', code: 'SI'),
  Countries(name: 'Solomon Islands', code: 'SB'),
  Countries(name: 'Somalia', code: 'SO'),
  Countries(name: 'South Africa', code: 'ZA'),
  Countries(name: 'South Georgia and the South Sandwich Islands', code: 'GS'),
  Countries(name: 'Spain', code: 'ES'),
  Countries(name: 'Sri Lanka', code: 'LK'),
  Countries(name: 'Sudan', code: 'SD'),
  Countries(name: 'Suriname', code: 'SR'),
  Countries(name: 'Svalbard and Jan Mayen', code: 'SJ'),
  Countries(name: 'Swaziland', code: 'SZ'),
  Countries(name: 'Sweden', code: 'SE'),
  Countries(name: 'Switzerland', code: 'CH'),
  Countries(name: 'Syrian Arab Republic', code: 'SY'),
  Countries(name: 'Taiwan, Province of China', code: 'TW'),
  Countries(name: 'Tajikistan', code: 'TJ'),
  Countries(name: 'Tanzania, United Republic of', code: 'TZ'),
  Countries(name: 'Thailand', code: 'TH'),
  Countries(name: 'Timor-Leste', code: 'TL'),
  Countries(name: 'Togo', code: 'TG'),
  Countries(name: 'Tokelau', code: 'TK'),
  Countries(name: 'Tonga', code: 'TO'),
  Countries(name: 'Trinidad and Tobago', code: 'TT'),
  Countries(name: 'Tunisia', code: 'TN'),
  Countries(name: 'Turkey', code: 'TR'),
  Countries(name: 'Turkmenistan', code: 'TM'),
  Countries(name: 'Turks and Caicos Islands', code: 'TC'),
  Countries(name: 'Tuvalu', code: 'TV'),
  Countries(name: 'Uganda', code: 'UG'),
  Countries(name: 'Ukraine', code: 'UA'),
  Countries(name: 'United Arab Emirates', code: 'AE'),
  Countries(name: 'United Kingdom', code: 'GB'),
  Countries(name: 'United States', code: 'US'),
  Countries(name: 'United States Minor Outlying Islands', code: 'UM'),
  Countries(name: 'Uruguay', code: 'UY'),
  Countries(name: 'Uzbekistan', code: 'UZ'),
  Countries(name: 'Vanuatu', code: 'VU'),
  Countries(name: 'Venezuela', code: 'VE'),
  Countries(name: 'Viet Nam', code: 'VN'),
  Countries(name: 'Virgin Islands, British', code: 'VG'),
  Countries(name: 'Virgin Islands, U.S.', code: 'VI'),
  Countries(name: 'Wallis and Futuna', code: 'WF'),
  Countries(name: 'Western Sahara', code: 'EH'),
  Countries(name: 'Yemen', code: 'YE'),
  Countries(name: 'Zambia', code: 'ZM'),
  Countries(name: 'Zimbabwe', code: 'ZW')
];
