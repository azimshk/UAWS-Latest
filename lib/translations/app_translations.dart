import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Auth Screen Translations
      'login': 'Login',
      'signup': 'Sign Up',
      'welcome_message': 'Log into your UAWS account',
      'signup_message': 'Create your account to help animals',
      'username_or_email': 'Username or Email',
      'username': 'Username',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'email': 'Email',
      'role': 'Role',
      'remember_me': 'Remember me',
      'sign_in': 'Sign In',
      'sign_in_google': 'Sign in with Google',
      'forgot_password': 'Forgot Password?',
      'create_account': 'Create Account',
      'dont_have_account': "Don't have an account? ",
      'already_have_account': "Already have an account? ",
      'create_one': 'Create one',
      'demo': 'Demo',

      // Input Hints
      'enter_username_email': 'Enter your username or email',
      'enter_password': 'Enter your password',
      'choose_username': 'Choose a username',
      'enter_email': 'Enter your email address',
      'enter_full_name': 'Enter your full name',
      'create_strong_password': 'Create a strong password',
      'reenter_password': 'Re-enter your password',

      // Validation Messages
      'username_email_required': 'Username or email is required',
      'username_required': 'Username is required',
      'email_required': 'Email is required',
      'password_required': 'Password is required',
      'username_min_length': 'Username must be at least 3 characters',
      'password_min_length': 'Password must be at least 6 characters',
      'display_name_required': 'Display name is required',
      'display_name_min_length': 'Display name must be at least 2 characters',
      'username_no_spaces': 'Username cannot contain spaces',
      'invalid_email': 'Please enter a valid email',
      'passwords_not_match': 'Passwords do not match',
      'confirm_password_required': 'Please confirm your password',
      'role_required': 'Please select a role',

      // Success Messages
      'success': 'Success',
      'login_successful': 'Login successful!',
      'google_signin_successful': 'Google sign-in successful!',
      'account_created': 'Account created successfully',

      // Error Messages
      'error': 'Error',
      'info': 'Info',
      'login_failed': 'Login failed',
      'something_wrong': 'Something went wrong. Please try again.',
      'google_signin_not_available': 'Google sign-in not available yet',

      // Roles
      'field_staff': 'Field Staff',
      'ngo_supervisor': 'NGO Supervisor',
      'municipal_readonly': 'Municipal Official',
      'admin': 'Admin',

      // Dashboard
      'welcome': 'Welcome',
      'dashboard': 'Dashboard',
      'uaws_dashboard': 'UAWS Dashboard',
      'user_information': 'User Information',
      'name': 'Name:',
      'role_label': 'Role:',
      'layer': 'Layer:',
      'city': 'City:',
      'wards': 'Wards:',
      'email_label': 'Email:',
      'coming_soon': 'Dashboard modules coming soon!',
      'modules_description': 'Sterilization, Vaccination, Bite Cases, and more...',
      'logout': 'Logout',

      // Demo Credentials
      'demo_credentials': 'Demo Credentials',
      'try_demo_accounts': 'Try these demo accounts:',
      'close': 'Close',
      'cancel': 'Cancel',
      'supervisor': 'Supervisor',
      'municipal': 'Municipal',

      // Reset Password
      'reset_password': 'Reset Password',
      'enter_email_reset': 'Enter your email to reset password:',

      // Navigation
      'page_not_found': 'Page Not Found',
      'page_not_exist': 'The page you are looking for does not exist.',
      'go_to_login': 'Go to Login',

      // App Title
      'app_title': 'UAWS Animal Welfare App',

      'signup_failed': 'Signup failed',
      'user': 'User',

      // Add to 'en_US' section:
      'field_dashboard': 'Field Staff Dashboard',
      'start_pickup_sterilization': 'Start Pickup (Sterilization)',
      'add_vaccination_entry': 'Add Vaccination Entry',
      'view_my_submissions': 'View My Submissions',
      'pickup_sterilization_desc': 'Begin sterilization animal pickup process',
      'vaccination_entry_desc': 'Record new vaccination administered',
      'submissions_desc': 'View your completed tasks and submissions',
      'assigned_area': 'Assigned Area',
      'quick_stats': 'Quick Stats',
      'today_pickups': 'Today\'s Pickups',
      'vaccinations': 'Vaccinations',
      'stats_coming_soon': 'Real-time stats coming soon',
      'sterilization_pickup': 'Sterilization Pickup',
      'vaccination_entry': 'Vaccination Entry',
      'my_submissions': 'My Submissions',

      // Add to 'en_US' section:
      'supervisor_dashboard': 'NGO Supervisor Dashboard',
      'sterilization_tracker_full': 'Sterilization Tracker (Full)',
      'bite_case_tracker_full': 'Bite Case Tracker (Full)',
      'rabies_surveillance': 'Rabies Surveillance',
      'quarantine_tracker': 'Quarantine Tracker',
      'education_tracker': 'Education Tracker',
      'monitor_field_staff': 'Monitor Field Staff Entries',
      'city_district_dashboard': 'City/District Dashboard',

// Descriptions
      'sterilization_tracker_desc': 'Complete sterilization monitoring and management',
      'bite_case_tracker_desc': 'Track and manage animal bite incidents',
      'rabies_surveillance_desc': 'Monitor rabies cases and vaccination status',
      'quarantine_tracker_desc': 'Manage animal quarantine procedures',
      'education_tracker_desc': 'Track community education programs',
      'monitor_field_staff_desc': 'Monitor field staff activities and submissions',
      'city_dashboard_desc': 'Overview of city/district animal welfare statistics',

// Stats and Labels
      'supervisor_overview': 'Supervisor Overview',
      'supervising_wards': 'Supervising Wards',
      'active_cases': 'Active Cases',
      'field_staff': 'Field Staff',
      'pending_reviews': 'Pending Reviews',
      'completed_today': 'Completed Today',
      'real_time_stats_coming_soon': 'Real-time statistics integration coming soon',


      // Add to 'en_US' section:
      'municipal_dashboard': 'Municipality Official Dashboard',
      'monitoring_city': 'Monitoring City',
      'view_only_access': 'VIEW ONLY ACCESS',
      'stats_overview': 'Statistics Overview',
      'sterilization_stats': 'Sterilization Statistics',
      'bite_case_stats': 'Bite Case Statistics',
      'rabies_stats': 'Rabies Statistics',
      'quick_actions': 'Quick Actions',
      'download_report': 'Download City Report',
      'photo_logs': 'Photo Logs',
      'quick_access': 'Quick Access',
      'refresh_stats': 'Refresh Statistics',
      'generating_report': 'Generating Report',
      'report_ready': 'Report Ready',

// Statistics Labels
      'total': 'Total',
      'thisMonth': 'This Month',
      'pending': 'Pending',
      'completed': 'Completed',
      'resolved': 'Resolved',
      'active': 'Active',
      'vaccinated': 'Vaccinated',
      'surveillance': 'Surveillance',

// Quick Access
      'monthly_report': 'Monthly Report',
      'current_month_summary': 'Current month summary',
      'photo_gallery': 'Photo Gallery',
      'field_photos_logs': 'Field photos & logs',
      'vaccination_data': 'Vaccination Data',
      'vaccination_statistics': 'Vaccination statistics',
      'ward_overview': 'Ward Overview',
      'ward_wise_statistics': 'Ward-wise statistics',

      // Add to 'en_US' section:
      'admin_dashboard': 'Central Admin Dashboard',
      'central_admin_access': 'Central Admin Access',
      'full_system_access': 'FULL SYSTEM ACCESS',
      'access_denied_admin': 'Access denied. Administrator permissions required.',

// Dashboard Features
      'city_center_dashboard': 'City/Center Dashboards',
      'view_dashboards_per_city_center': 'View detailed dashboards for each city and center',
      'opening_city_center_dashboard': 'Opening city/center dashboard interface...',

      'auto_report_generation': 'Auto-Report Generation',
      'generate_reports_1st_5th': 'Generate automated reports (1st-5th of month)',
      'generating_reports_1st_5th': 'Generating automated reports for 1st-5th...',
      'generating_reports': 'Generating reports...',
      'reports_generated_successfully': 'Reports generated successfully!',
      'report_generation_failed': 'Report generation failed. Please try again.',

      'user_management': 'User Management',
      'manage_users_roles_permissions': 'Manage users, roles, and permissions',
      'opening_user_management': 'Opening user management interface...',

      'full_tracker_access': 'Full Tracker Access',
      'access_all_trackers_and_data': 'Access all trackers and data across system',
      'opening_full_tracker_access': 'Opening full tracker access interface...',

// Logout Dialog
      'confirm_logout': 'Confirm Logout',
      'are_you_sure_logout': 'Are you sure you want to logout from admin dashboard?',
      'logout_warning_admin': 'This will end your administrative session.',
      'logging_out': 'Logging Out',
      'admin_session_ending': 'Administrative session ending...',

// Stats
      'total_cities': 'Total Cities',
      'total_users': 'Total Users',
      'active_reports': 'Active Reports',
      'pending_approvals': 'Pending Approvals',
      'admin_stats_updated': 'Admin statistics updated successfully',

// System Overview
      'system_overview': 'System Overview',
      'admin_capabilities': 'Administrative Capabilities:',
      'manage_all_cities_centers': 'Manage all cities and centers',
      'automated_report_generation': 'Automated report generation',
      'complete_user_management': 'Complete user management',
      'full_data_access_control': 'Full data access and control',
      'layer_3_admin_access': 'Layer 3 - Full Administrative Access',


      // Munciple Logout:
      // Add to 'en_US' section:
      'confirm_logout': 'Confirm Logout',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'logout_warning_municipal': 'This will end your municipal monitoring session and return you to login.',
      'logging_out': 'Logging Out',
      'municipal_session_ending': 'Municipal monitoring session ending...',
      'cancel': 'Cancel',
      'logout': 'Logout',


      // Add to 'en_US' section:
      'confirm_logout': 'Confirm Logout',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'logout_warning_field_staff': 'This will end your field staff session and return you to login.',
      'logging_out': 'Logging Out',
      'field_staff_session_ending': 'Field staff session ending...',
      'cancel': 'Cancel',
      'logout': 'Logout',

      // Logout of Supervisor
      'confirm_logout': 'Confirm Logout',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'logout_warning_supervisor': 'This will end your supervisor session and return you to login.',
      'logging_out': 'Logging Out',
      'supervisor_session_ending': 'Supervisor session ending...',
      'cancel': 'Cancel',
      'logout': 'Logout',




    },

    'mr_IN': {
      // Auth Screen Translations
      'login': 'लॉगिन',
      'signup': 'नोंदणी करा',
      'welcome_message': 'तुमच्या UAWS खात्यात लॉगिन करा',
      'signup_message': 'प्राण्यांना मदत करण्यासाठी तुमचे खाते तयार करा',
      'username_or_email': 'वापरकर्तानाव किंवा ईमेल',
      'username': 'वापरकर्तानाव',
      'password': 'पासवर्ड',
      'confirm_password': 'पासवर्डची पुष्टी करा',
      'full_name': 'पूर्ण नाव',
      'email': 'ईमेल',
      'role': 'भूमिका',
      'remember_me': 'मला लक्षात ठेवा',
      'sign_in': 'साइन इन',
      'sign_in_google': 'Google सह साइन इन करा',
      'forgot_password': 'पासवर्ड विसरलात?',
      'create_account': 'खाते तयार करा',
      'dont_have_account': "खाते नाही? ",
      'already_have_account': "आधीच खाते आहे? ",
      'create_one': 'एक तयार करा',
      'demo': 'डेमो',

      // Input Hints
      'enter_username_email': 'तुमचे वापरकर्तानाव किंवा ईमेल टाका',
      'enter_password': 'तुमचा पासवर्ड टाका',
      'choose_username': 'वापरकर्तानाव निवडा',
      'enter_email': 'तुमचा ईमेल पत्ता टाका',
      'enter_full_name': 'तुमचे पूर्ण नाव टाका',
      'create_strong_password': 'मजबूत पासवर्ड तयार करा',
      'reenter_password': 'पासवर्ड पुन्हा टाका',

      // Validation Messages
      'username_email_required': 'वापरकर्तानाव किंवा ईमेल आवश्यक आहे',
      'username_required': 'वापरकर्तानाव आवश्यक आहे',
      'email_required': 'ईमेल आवश्यक आहे',
      'password_required': 'पासवर्ड आवश्यक आहे',
      'username_min_length': 'वापरकर्तानाव कमीत कमी 3 अक्षरांचे असावे',
      'password_min_length': 'पासवर्ड कमीत कमी 6 अक्षरांचा असावा',
      'display_name_required': 'प्रदर्शन नाव आवश्यक आहे',
      'display_name_min_length': 'प्रदर्शन नाव कमीत कमी 2 अक्षरांचे असावे',
      'username_no_spaces': 'वापरकर्तानावात रिक्त जागा असू शकत नाही',
      'invalid_email': 'कृपया वैध ईमेल टाका',
      'passwords_not_match': 'पासवर्ड जुळत नाहीत',
      'confirm_password_required': 'कृपया तुमच्या पासवर्डची पुष्टी करा',
      'role_required': 'कृपया भूमिका निवडा',

      // Success Messages
      'success': 'यशस्वी',
      'login_successful': 'लॉगिन यशस्वी!',
      'google_signin_successful': 'Google साइन-इन यशस्वी!',
      'account_created': 'खाते यशस्वीरित्या तयार केले',

      // Error Messages
      'error': 'त्रुटी',
      'info': 'माहिती',
      'login_failed': 'लॉगिन अयशस्वी',
      'something_wrong': 'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.',
      'google_signin_not_available': 'Google साइन-इन अद्याप उपलब्ध नाही',

      // Roles
      'field_staff': 'फील्ड स्टाफ',
      'ngo_supervisor': 'NGO पर्यवेक्षक',
      'municipal_readonly': 'नगरपालिका अधिकारी',
      'admin': 'प्रशासक',

      // Dashboard
      'welcome': 'स्वागत',
      'dashboard': 'डॅशबोर्ड',
      'uaws_dashboard': 'UAWS डॅशबोर्ड',
      'user_information': 'वापरकर्ता माहिती',
      'name': 'नाव:',
      'role_label': 'भूमिका:',
      'layer': 'स्तर:',
      'city': 'शहर:',
      'wards': 'प्रभाग:',
      'email_label': 'ईमेल:',
      'coming_soon': 'डॅशबोर्ड मॉड्यूल लवकरच येत आहेत!',
      'modules_description': 'नसबंदी, लसीकरण, चावण्याच्या घटना आणि बरेच काही...',
      'logout': 'लॉगआउट',

      // Demo Credentials
      'demo_credentials': 'डेमो क्रेडेंशियल्स',
      'try_demo_accounts': 'हे डेमो खाते वापरून पहा:',
      'close': 'बंद करा',
      'cancel': 'रद्द करा',
      'supervisor': 'पर्यवेक्षक',
      'municipal': 'नगरपालिका',

      // Reset Password
      'reset_password': 'पासवर्ड रीसेट करा',
      'enter_email_reset': 'पासवर्ड रीसेट करण्यासाठी तुमचा ईमेल टाका:',

      // Navigation
      'page_not_found': 'पेज सापडला नाही',
      'page_not_exist': 'तुम्ही शोधत असलेले पेज अस्तित्वात नाही.',
      'go_to_login': 'लॉगिनवर जा',

      // App Title
      'app_title': 'UAWS प्राणी कल्याण अॅप',

      'signup_failed': 'साइनअप अयशस्वी',
      'user': 'वापरकर्ता',

      // Add to 'mr_IN' section:
      'field_dashboard': 'फील्ड स्टाफ डॅशबोर्ड',
      'start_pickup_sterilization': 'पिकअप सुरू करा (नसबंदी)',
      'add_vaccination_entry': 'लसीकरण नोंद जोडा',
      'view_my_submissions': 'माझे सबमिशन पहा',
      'pickup_sterilization_desc': 'नसबंदी प्राणी पिकअप प्रक्रिया सुरू करा',
      'vaccination_entry_desc': 'दिलेले नवीन लसीकरण नोंदवा',
      'submissions_desc': 'तुमची पूर्ण झालेली कामे आणि सबमिशन पहा',
      'assigned_area': 'नियुक्त क्षेत्र',
      'quick_stats': 'त्वरित आकडेवारी',
      'today_pickups': 'आजचे पिकअप',
      'vaccinations': 'लसीकरण',
      'stats_coming_soon': 'रिअल-टाइम आकडेवारी लवकरच',
      'sterilization_pickup': 'नसबंदी पिकअप',
      'vaccination_entry': 'लसीकरण नोंद',
      'my_submissions': 'माझे सबमिशन',

      // Add to 'mr_IN' section:
      'supervisor_dashboard': 'NGO पर्यवेक्षक डॅशबोर्ड',
      'sterilization_tracker_full': 'नसबंदी ट्रॅकर (पूर्ण)',
      'bite_case_tracker_full': 'चावणे प्रकरण ट्रॅकर (पूर्ण)',
      'rabies_surveillance': 'रेबीज पाळत ठेवणे',
      'quarantine_tracker': 'क्वारंटाइन ट्रॅकर',
      'education_tracker': 'शिक्षण ट्रॅकर',
      'monitor_field_staff': 'फील्ड स्टाफ नोंदी निरीक्षण करा',
      'city_district_dashboard': 'शहर/जिल्हा डॅशबोर्ड',

// Descriptions
      'sterilization_tracker_desc': 'संपूर्ण नसबंदी निरीक्षण आणि व्यवस्थापन',
      'bite_case_tracker_desc': 'प्राणी चावण्याच्या घटनांचा मागोवा घ्या आणि व्यवस्थापन करा',
      'rabies_surveillance_desc': 'रेबीज प्रकरणे आणि लसीकरण स्थितीचे निरीक्षण करा',
      'quarantine_tracker_desc': 'प्राणी क्वारंटाइन प्रक्रिया व्यवस्थापित करा',
      'education_tracker_desc': 'समुदायिक शिक्षण कार्यक्रमांचा मागोवा घ्या',
      'monitor_field_staff_desc': 'फील्ड स्टाफ क्रियाकलाप आणि सबमिशनचे निरीक्षण करा',
      'city_dashboard_desc': 'शहर/जिल्हा प्राणी कल्याण आकडेवारीचे विहंगावलोकन',

// Stats and Labels
      'supervisor_overview': 'पर्यवेक्षक विहंगावलोकन',
      'supervising_wards': 'पर्यवेक्षण प्रभाग',
      'active_cases': 'सक्रिय प्रकरणे',
      'field_staff': 'फील्ड स्टाफ',
      'pending_reviews': 'प्रलंबित पुनरावलोकने',
      'completed_today': 'आज पूर्ण झाले',
      'real_time_stats_coming_soon': 'रिअल-टाइम आकडेवारी एकीकरण लवकरच येत आहे',

      // Add to 'mr_IN' section:
      'municipal_dashboard': 'नगरपालिका अधिकारी डॅशबोर्ड',
      'monitoring_city': 'निरीक्षण शहर',
      'view_only_access': 'केवळ दृश्य प्रवेश',
      'stats_overview': 'आकडेवारी विहंगावलोकन',
      'sterilization_stats': 'नसबंदी आकडेवारी',
      'bite_case_stats': 'चावणे प्रकरण आकडेवारी',
      'rabies_stats': 'रेबीज आकडेवारी',
      'quick_actions': 'त्वरित क्रिया',
      'download_report': 'शहर अहवाल डाउनलोड करा',
      'photo_logs': 'फोटो लॉग',
      'quick_access': 'त्वरित प्रवेश',
      'refresh_stats': 'आकडेवारी रीफ्रेश करा',
      'generating_report': 'अहवाल तयार करत आहे',
      'report_ready': 'अहवाल तयार',

// Statistics Labels
      'total': 'एकूण',
      'thisMonth': 'या महिन्यात',
      'pending': 'प्रलंबित',
      'completed': 'पूर्ण',
      'resolved': 'निराकरण',
      'active': 'सक्रिय',
      'vaccinated': 'लसीकरण केले',
      'surveillance': 'पाळत ठेवणे',

// Quick Access
      'monthly_report': 'मासिक अहवाल',
      'current_month_summary': 'चालू महिन्याचा सारांश',
      'photo_gallery': 'फोटो गॅलरी',
      'field_photos_logs': 'फील्ड फोटो आणि लॉग',
      'vaccination_data': 'लसीकरण डेटा',
      'vaccination_statistics': 'लसीकरण आकडेवारी',
      'ward_overview': 'प्रभाग विहंगावलोकन',
      'ward_wise_statistics': 'प्रभागानुसार आकडेवारी',

// Add to 'mr_IN' section:
      'admin_dashboard': 'केंद्रीय प्रशासक डॅशबोर्ड',
      'central_admin_access': 'केंद्रीय प्रशासक प्रवेश',
      'full_system_access': 'संपूर्ण सिस्टम प्रवेश',
      'access_denied_admin': 'प्रवेश नाकारला. प्रशासक परवानगी आवश्यक.',

// Dashboard Features
      'city_center_dashboard': 'शहर/केंद्र डॅशबोर्ड',
      'view_dashboards_per_city_center': 'प्रत्येक शहर आणि केंद्रासाठी तपशीलवार डॅशबोर्ड पहा',
      'opening_city_center_dashboard': 'शहर/केंद्र डॅशबोर्ड इंटरफेस उघडत आहे...',

      'auto_report_generation': 'स्वयं-अहवाल निर्मिती',
      'generate_reports_1st_5th': 'स्वयंचलित अहवाल तयार करा (महिन्याच्या 1-5)',
      'generating_reports_1st_5th': '1-5 तारखेसाठी स्वयंचलित अहवाल तयार करत आहे...',
      'generating_reports': 'अहवाल तयार करत आहे...',
      'reports_generated_successfully': 'अहवाल यशस्वीरित्या तयार केले!',
      'report_generation_failed': 'अहवाल निर्मिती अयशस्वी. कृपया पुन्हा प्रयत्न करा.',

      'user_management': 'वापरकर्ता व्यवस्थापन',
      'manage_users_roles_permissions': 'वापरकर्ते, भूमिका आणि परवानग्या व्यवस्थापित करा',
      'opening_user_management': 'वापरकर्ता व्यवस्थापन इंटरफेस उघडत आहे...',

      'full_tracker_access': 'संपूर्ण ट्रॅकर प्रवेश',
      'access_all_trackers_and_data': 'सिस्टममधील सर्व ट्रॅकर आणि डेटामध्ये प्रवेश',
      'opening_full_tracker_access': 'संपूर्ण ट्रॅकर प्रवेश इंटरफेस उघडत आहे...',

// Logout Dialog
      'confirm_logout': 'लॉगआउट पुष्टी करा',
      'are_you_sure_logout': 'तुम्हाला खात्री आहे की तुम्ही प्रशासक डॅशबोर्डमधून लॉगआउट करू इच्छिता?',
      'logout_warning_admin': 'हे तुमचे प्रशासकीय सत्र समाप्त करेल.',
      'logging_out': 'लॉगआउट करत आहे',
      'admin_session_ending': 'प्रशासकीय सत्र समाप्त होत आहे...',

// Stats
      'total_cities': 'एकूण शहरे',
      'total_users': 'एकूण वापरकर्ते',
      'active_reports': 'सक्रिय अहवाल',
      'pending_approvals': 'प्रलंबित मंजुरी',
      'admin_stats_updated': 'प्रशासक आकडेवारी यशस्वीरित्या अद्यतनित केली',

// System Overview
      'system_overview': 'सिस्टम विहंगावलोकन',
      'admin_capabilities': 'प्रशासकीय क्षमता:',
      'manage_all_cities_centers': 'सर्व शहरे आणि केंद्रे व्यवस्थापित करा',
      'automated_report_generation': 'स्वयंचलित अहवाल निर्मिती',
      'complete_user_management': 'संपूर्ण वापरकर्ता व्यवस्थापन',
      'full_data_access_control': 'संपूर्ण डेटा प्रवेश आणि नियंत्रण',
      'layer_3_admin_access': 'स्तर 3 - संपूर्ण प्रशासकीय प्रवेश',




// Logout of Supervisor:
      'confirm_logout': 'लॉगआउट पुष्टी करा',
      'are_you_sure_logout': 'तुम्हाला खात्री आहे की तुम्ही लॉगआउट करू इच्छिता?',
      'logout_warning_supervisor': 'हे तुमचे पर्यवेक्षक सत्र समाप्त करेल आणि तुम्हाला लॉगिनवर परत करेल.',
      'logging_out': 'लॉगआउट करत आहे',
      'supervisor_session_ending': 'पर्यवेक्षक सत्र समाप्त होत आहे...',
      'cancel': 'रद्द करा',
      'logout': 'लॉगआउट',



// Add to 'mr_IN' section:
      'confirm_logout': 'लॉगआउट पुष्टी करा',
      'are_you_sure_logout': 'तुम्हाला खात्री आहे की तुम्ही लॉगआउट करू इच्छिता?',
      'logout_warning_field_staff': 'हे तुमचे फील्ड स्टाफ सत्र समाप्त करेल आणि तुम्हाला लॉगिनवर परत करेल.',
      'logging_out': 'लॉगआउट करत आहे',
      'field_staff_session_ending': 'फील्ड स्टाफ सत्र समाप्त होत आहे...',
      'cancel': 'रद्द करा',
      'logout': 'लॉगआउट',

      // Add to 'mr_IN' section:
      'confirm_logout': 'लॉगआउट पुष्टी करा',
      'are_you_sure_logout': 'तुम्हाला खात्री आहे की तुम्ही लॉगआउट करू इच्छिता?',
      'logout_warning_municipal': 'हे तुमचे नगरपालिका निरीक्षण सत्र समाप्त करेल आणि तुम्हाला लॉगिनवर परत करेल.',
      'logging_out': 'लॉगआउट करत आहे',
      'municipal_session_ending': 'नगरपालिका निरीक्षण सत्र समाप्त होत आहे...',
      'cancel': 'रद्द करा',
      'logout': 'लॉगआउट',





    },
  };
}
