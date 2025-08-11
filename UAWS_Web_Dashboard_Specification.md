# UAWS Management Web Dashboard - Technical Specification

## 💻 **Application Overview**

**App Name:** UAWS Management Dashboard  
**Target Users:** Layer 2 (NGO Supervisors), Layer 2B (Municipal Officials), Layer 3 (Admins)  
**Platform:** Progressive Web App (PWA)  
**Primary Purpose:** Comprehensive management, monitoring, and reporting system

---

## 🎯 **Core Features by User Layer**

### **Layer 2 (NGO Supervisors) - Full Operational Access**

-   ✅ Complete Sterilization Tracker (Pickup → Operation → Release)
-   ✅ Bite Case Tracker
-   ✅ Quarantine Tracker (10-day observation)
-   ✅ Rabies Case Surveillance
-   ✅ Education Initiative Tracker
-   ✅ Ward Management (Create, Read, Update)
-   ✅ Ward/City dashboards
-   ✅ Data validation & quality checks
-   ✅ Team management (field staff)

### **Layer 2B (Municipal Officials) - Read-Only Access**

-   📊 Dashboard views (all modules)
-   📊 Reports and analytics
-   📊 Statistical summaries
-   📊 Export capabilities
-   📊 Photo/proof verification
-   📊 Ward maps and territorial data
-   ❌ No create/edit/delete permissions

### **Layer 3 (Admins) - Super Admin Access**

-   🔧 Everything from Layer 2
-   🔧 User management (all layers)
-   🔧 System configuration
-   🔧 Hospital/city management
-   🔧 Ward management (Full CRUD)
-   🔧 Automated report generation
-   🔧 Audit logs and compliance
-   🔧 Data export/import tools

---

## 🔄 **Cross-Platform Database Consistency**

### **Shared Firestore Collections with Mobile App**

```typescript
// Field Value Standards (Synchronized with Mobile App)
type Species = "Dog" | "Cat";
type Sex = "Male" | "Female" | "Unnoticed";
type AgeGroup = "Puppy/Kitten" | "Young" | "Adult" | "Senior";
type VaccineType = "Rabies" | "DHPP" | "Others";
type AnimalCondition = "Healthy" | "Injured" | "Sick";

// Shared Collections (Mobile App has limited access)
const SharedCollections = {
    sterilizations: "sterilizations", // Mobile: pickup only, Web: full 3-stage
    vaccination_tracker: "vaccination_tracker", // Mobile: full access, Web: full access
    users: "users", // Both: profile management
    cities: "cities", // Web only: admin management
    hospitals: "hospitals", // Web only: admin management
    wards: "wards", // Web only: territorial administration
};

// Web Dashboard Exclusive Collections
const WebOnlyCollections = {
    biteCases: "biteCases", // Layer 2+ only
    quarantineRecords: "quarantineRecords", // Layer 2+ only
    rabiesCases: "rabiesCases", // Layer 2+ only
    educationCampaigns: "educationCampaigns", // Layer 2+ only
    reports: "reports", // Layer 3 only
};
```

### **Data Synchronization Rules**

```typescript
// Mobile → Web Sync Priority
1. Sterilization pickup data syncs to web dashboard operation queue
2. Vaccination records sync in real-time for due date calculations
3. User activity logs sync for audit trails
4. GPS and photo data compressed before cloud storage upload

// Web → Mobile Sync Priority
1. User profile updates and permission changes
2. Hospital and city configuration data
3. Vaccination due date reminders and batch updates
```

---

## 🏗️ **Technical Stack**

### **Frontend Framework**

```
Next.js 15+ (React 18+)
- App Router (stable)
- Server Components
- Streaming & Suspense
- API routes
- Performance optimization
- SEO friendly
```

### **UI Component Library**

```
shadcn/ui + Tailwind CSS
- Modern component library
- Customizable and composable
- Accessibility compliant
- Copy-paste components
- Radix UI primitives
- TypeScript first
```

### **State Management**

```
Redux Toolkit + RTK Query
- Centralized state management
- API caching and invalidation
- Real-time updates
- Optimistic updates
```

### **Backend & Database**

```
Firebase Suite
- Firestore (NoSQL database)
- Firebase Auth (Authentication)
- Firebase Storage (File uploads)
- Firebase Functions (Server-side logic)
- Firebase Hosting (Deployment)
```

### **Key Dependencies**

```json
{
    "dependencies": {
        "next": "^15.0.0",
        "react": "^18.2.0",
        "react-dom": "^18.2.0",
        "@radix-ui/react-accordion": "^1.1.2",
        "@radix-ui/react-alert-dialog": "^1.0.5",
        "@radix-ui/react-avatar": "^1.0.4",
        "@radix-ui/react-checkbox": "^1.0.4",
        "@radix-ui/react-dialog": "^1.0.5",
        "@radix-ui/react-dropdown-menu": "^2.0.6",
        "@radix-ui/react-label": "^2.0.2",
        "@radix-ui/react-popover": "^1.0.7",
        "@radix-ui/react-select": "^2.0.0",
        "@radix-ui/react-separator": "^1.0.3",
        "@radix-ui/react-slider": "^1.1.2",
        "@radix-ui/react-switch": "^1.0.3",
        "@radix-ui/react-tabs": "^1.0.4",
        "@radix-ui/react-toast": "^1.1.5",
        "class-variance-authority": "^0.7.0",
        "clsx": "^2.0.0",
        "tailwind-merge": "^2.0.0",
        "lucide-react": "^0.294.0",
        "@reduxjs/toolkit": "^1.9.0",
        "react-redux": "^8.1.0",
        "firebase": "^10.4.0",
        "react-firebase-hooks": "^5.1.1",
        "recharts": "^2.8.0",
        "react-hook-form": "^7.45.0",
        "yup": "^1.2.0",
        "@hookform/resolvers": "^3.3.0",
        "date-fns": "^2.30.0",
        "react-dropzone": "^14.2.3",
        "jspdf": "^2.5.1",
        "xlsx": "^0.18.5",
        "react-image-gallery": "^1.3.0",
        "leaflet": "^1.9.4",
        "react-leaflet": "^4.2.1"
    },
    "devDependencies": {
        "@types/node": "^20.7.0",
        "@types/react": "^18.2.21",
        "@types/react-dom": "^18.2.7",
        "tailwindcss": "^3.4.0",
        "autoprefixer": "^10.4.0",
        "postcss": "^8.4.0",
        "typescript": "^5.2.2",
        "eslint": "^8.49.0",
        "eslint-config-next": "^13.5.0"
    }
}
```

---

## 📁 **Application Architecture**

```
uaws-dashboard/
├── public/
│   ├── icons/
│   ├── images/
│   └── manifest.json
├── src/
│   ├── components/
│   │   ├── common/
│   │   │   ├── Layout/
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   ├── Header.tsx
│   │   │   │   ├── Breadcrumb.tsx
│   │   │   │   └── Footer.tsx
│   │   │   ├── Forms/
│   │   │   │   ├── FormField.tsx
│   │   │   │   ├── ImageUpload.tsx
│   │   │   │   ├── GPSPicker.tsx
│   │   │   │   └── DateTimePicker.tsx
│   │   │   ├── Tables/
│   │   │   │   ├── DataTable.tsx
│   │   │   │   ├── TableFilters.tsx
│   │   │   │   └── ExportButton.tsx
│   │   │   └── Charts/
│   │   │       ├── BarChart.tsx
│   │   │       ├── LineChart.tsx
│   │   │       ├── PieChart.tsx
│   │   │       └── StatCard.tsx
│   │   ├── sterilization/
│   │   │   ├── SterilizationForm.tsx
│   │   │   ├── SterilizationList.tsx
│   │   │   ├── SterilizationDetails.tsx
│   │   │   ├── OperationForm.tsx
│   │   │   └── ReleaseForm.tsx
│   │   ├── vaccination/
│   │   │   ├── VaccinationForm.tsx
│   │   │   ├── VaccinationList.tsx
│   │   │   └── VaccinationCalendar.tsx
│   │   ├── biteCases/
│   │   │   ├── BiteCaseForm.tsx
│   │   │   ├── BiteCaseList.tsx
│   │   │   └── BiteCaseMap.tsx
│   │   ├── quarantine/
│   │   │   ├── QuarantineForm.tsx
│   │   │   ├── QuarantineList.tsx
│   │   │   ├── DailyObservation.tsx
│   │   │   └── QuarantineCalendar.tsx
│   │   ├── rabies/
│   │   │   ├── RabiesForm.tsx
│   │   │   ├── RabiesList.tsx
│   │   │   └── RabiesMap.tsx
│   │   ├── education/
│   │   │   ├── EducationForm.tsx
│   │   │   ├── EducationList.tsx
│   │   │   └── CampaignCalendar.tsx
│   │   ├── wards/
│   │   │   ├── WardForm.tsx
│   │   │   ├── WardList.tsx
│   │   │   ├── WardMap.tsx
│   │   │   └── WardManagement.tsx
│   │   ├── dashboard/
│   │   │   ├── Overview.tsx
│   │   │   ├── CityDashboard.tsx
│   │   │   ├── WardDashboard.tsx
│   │   │   ├── HospitalDashboard.tsx
│   │   │   └── ReportsSection.tsx
│   │   └── admin/
│   │       ├── UserManagement.tsx
│   │       ├── CityManagement.tsx
│   │       ├── HospitalManagement.tsx
│   │       ├── WardManagement.tsx
│   │       └── SystemSettings.tsx
│   ├── pages/
│   │   ├── api/
│   │   │   ├── auth/
│   │   │   ├── reports/
│   │   │   └── export/
│   │   ├── auth/
│   │   │   ├── login.tsx
│   │   │   └── profile.tsx
│   │   ├── dashboard/
│   │   │   ├── index.tsx
│   │   │   ├── overview.tsx
│   │   │   ├── city/[cityId].tsx
│   │   │   └── ward/[wardId].tsx
│   │   ├── sterilization/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── vaccination/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── bite-cases/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── quarantine/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── rabies/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── education/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── wards/
│   │   │   ├── index.tsx
│   │   │   ├── new.tsx
│   │   │   └── [id].tsx
│   │   ├── reports/
│   │   │   ├── index.tsx
│   │   │   ├── monthly.tsx
│   │   │   ├── custom.tsx
│   │   │   └── audit.tsx
│   │   ├── admin/
│   │   │   ├── users.tsx
│   │   │   ├── cities.tsx
│   │   │   ├── hospitals.tsx
│   │   │   ├── wards.tsx
│   │   │   └── settings.tsx
│   │   ├── _app.tsx
│   │   ├── _document.tsx
│   │   └── index.tsx
│   ├── services/
│   │   ├── firebase/
│   │   │   ├── config.ts
│   │   │   ├── auth.ts
│   │   │   ├── firestore.ts
│   │   │   └── storage.ts
│   │   ├── api/
│   │   │   ├── sterilizationApi.ts
│   │   │   ├── vaccinationApi.ts
│   │   │   ├── biteCaseApi.ts
│   │   │   ├── quarantineApi.ts
│   │   │   ├── rabiesApi.ts
│   │   │   ├── educationApi.ts
│   │   │   ├── reportsApi.ts
│   │   │   ├── userApi.ts
│   │   │   └── wardApi.ts
│   │   ├── reports/
│   │   │   ├── pdfGenerator.ts
│   │   │   ├── excelExporter.ts
│   │   │   └── reportScheduler.ts
│   │   └── utils/
│   │       ├── validation.ts
│   │       ├── dateUtils.ts
│   │       ├── permissions.ts
│   │       └── constants.ts
│   ├── store/
│   │   ├── slices/
│   │   │   ├── authSlice.ts
│   │   │   ├── sterilizationSlice.ts
│   │   │   ├── vaccinationSlice.ts
│   │   │   ├── biteCaseSlice.ts
│   │   │   ├── quarantineSlice.ts
│   │   │   ├── rabiesSlice.ts
│   │   │   ├── educationSlice.ts
│   │   │   ├── reportsSlice.ts
│   │   │   ├── wardSlice.ts
│   │   │   └── uiSlice.ts
│   │   ├── api/
│   │   │   └── baseApi.ts
│   │   └── store.ts
│   ├── types/
│   │   ├── auth.ts
│   │   ├── sterilization.ts
│   │   ├── vaccination.ts
│   │   ├── biteCases.ts
│   │   ├── quarantine.ts
│   │   ├── rabies.ts
│   │   ├── education.ts
│   │   ├── ward.ts
│   │   └── common.ts
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── usePermissions.ts
│   │   ├── useRealtime.ts
│   │   └── useExport.ts
│   └── styles/
│       ├── globals.css
│       ├── components.css
│       └── theme.ts
├── next.config.js
├── package.json
└── tsconfig.json
```

---

## 🔐 **Authentication & Authorization**

### **Role-Based Access Control**

```typescript
// types/auth.ts
export interface User {
    uid: string;
    name: string;
    email: string;
    phone: string;
    role: "field_staff" | "ngo_supervisor" | "municipal_readonly" | "admin";
    layer: "Layer1" | "Layer2" | "Layer2B" | "Layer3";
    assignedCity: string;
    assignedWard: string[];
    permissions: {
        sterilization: Permission;
        vaccination: Permission;
        biteCases: Permission;
        quarantine: Permission;
        rabies: Permission;
        education: Permission;
        wards: Permission;
    };
    isActive: boolean;
    lastLogin: Date;
    createdAt: Date;
}

interface Permission {
    create: boolean;
    read: boolean;
    update: boolean;
    delete: boolean;
}
```

### **Permission Hook**

```typescript
// hooks/usePermissions.ts
export const usePermissions = () => {
    const { user } = useAuth();

    const hasPermission = (module: string, action: string): boolean => {
        if (!user) return false;
        return user.permissions[module]?.[action] || false;
    };

    const canAccess = (layer: string[]): boolean => {
        if (!user) return false;
        return layer.includes(user.layer);
    };

    return { hasPermission, canAccess, user };
};
```

---

## 📊 **Dashboard Components**

### **Overview Dashboard**

```typescript
// components/dashboard/Overview.tsx
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { MedicalServices, Pets, Report, Warning } from "lucide-react";

interface DashboardStats {
    totalSterilizations: number;
    totalVaccinations: number;
    pendingOperations: number;
    activeBiteCases: number;
    quarantineAnimals: number;
    rabiesCases: number;
    monthlyEducationEvents: number;
    trendsData: ChartData[];
}

const Overview: React.FC = () => {
    const { data: stats, isLoading } = useGetDashboardStatsQuery();
    const { canAccess } = usePermissions();

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* Statistics Cards */}
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">
                        Total Sterilizations
                    </CardTitle>
                    <MedicalServices className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">
                        {stats?.totalSterilizations}
                    </div>
                    <Badge variant="secondary" className="text-xs">
                        +12% from last month
                    </Badge>
                </CardContent>
            </Card>

            {/* Charts */}
            <div className="col-span-2">
                <TrendsChart data={stats?.trendsData} />
            </div>

            {/* Recent Activities */}
            <div className="col-span-1">
                <RecentActivities />
            </div>

            {/* Ward Performance */}
            {canAccess(["Layer2", "Layer3"]) && (
                <div className="col-span-full">
                    <WardPerformanceTable />
                </div>
            )}
        </div>
    );
};
```

### **Sterilization 3-Stage Tracker**

```typescript
// components/sterilization/SterilizationDetails.tsx
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { CheckCircle, Circle, Clock } from "lucide-react";

interface SterilizationRecord {
    id: string;
    // Animal details
    species: "Dog" | "Cat";
    sex: "Male" | "Female" | "Unnoticed";
    ageGroup: "Puppy/Kitten" | "Young" | "Adult" | "Senior";
    ward: string;
    zone: string;
    tagNumber: string;
    cageNumber: string;
    identificationMarks: string;

    // Pickup stage
    pickup: {
        dateTime: Date;
        photoURL: string;
        gps: { lat: number; lng: number };
        pickedBy: string;
    };

    // Operation stage
    operation?: {
        status: "Operated" | "Not Operated";
        date: Date;
        surgeonId: string;
        photoURL?: string;
        complications: { exists: boolean; remarks?: string };
    };

    // Release stage
    release?: {
        date: Date;
        releasedBy: string;
        photoURL?: string;
        status: "Released" | "Death" | "Postponed";
        notes: string;
        gps?: { lat: number; lng: number };
    };

    createdAt: Date;
    createdBy: string;
}

const SterilizationTracker: React.FC = () => {
    const currentStep = getActiveStep();

    return (
        <div className="space-y-6">
            {/* Progress Steps */}
            <div className="flex items-center space-x-4">
                <div className="flex items-center space-x-2">
                    {currentStep >= 1 ? (
                        <CheckCircle className="h-5 w-5 text-green-500" />
                    ) : (
                        <Circle className="h-5 w-5 text-gray-300" />
                    )}
                    <span
                        className={
                            currentStep >= 1
                                ? "font-medium"
                                : "text-muted-foreground"
                        }
                    >
                        Pickup
                    </span>
                </div>
                <Separator orientation="horizontal" className="flex-1" />
                <div className="flex items-center space-x-2">
                    {currentStep >= 2 ? (
                        <CheckCircle className="h-5 w-5 text-green-500" />
                    ) : currentStep === 1 ? (
                        <Clock className="h-5 w-5 text-amber-500" />
                    ) : (
                        <Circle className="h-5 w-5 text-gray-300" />
                    )}
                    <span
                        className={
                            currentStep >= 2
                                ? "font-medium"
                                : currentStep === 1
                                ? "text-amber-600"
                                : "text-muted-foreground"
                        }
                    >
                        Operation
                    </span>
                </div>
                <Separator orientation="horizontal" className="flex-1" />
                <div className="flex items-center space-x-2">
                    {currentStep >= 3 ? (
                        <CheckCircle className="h-5 w-5 text-green-500" />
                    ) : currentStep === 2 ? (
                        <Clock className="h-5 w-5 text-amber-500" />
                    ) : (
                        <Circle className="h-5 w-5 text-gray-300" />
                    )}
                    <span
                        className={
                            currentStep >= 3
                                ? "font-medium"
                                : currentStep === 2
                                ? "text-amber-600"
                                : "text-muted-foreground"
                        }
                    >
                        Release
                    </span>
                </div>
            </div>

            {/* Stage Forms */}
            {currentStep === 0 && <PickupStageForm />}
            {currentStep === 1 && <OperationStageForm />}
            {currentStep === 2 && <ReleaseStageForm />}
        </div>
    );
};
```

### **Quarantine Tracker (10-Day Observation)**

```typescript
// components/quarantine/QuarantineTracker.tsx
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Calendar, Eye, FileText } from "lucide-react";

interface QuarantineRecord {
    id: string;
    animalId: string;
    tagNumber: string;
    cageNumber: string;
    pickupDate: Date;
    quarantineStartDate: Date;
    quarantineEndDate: Date;
    location: {
        pickupWard: string;
        gps: { lat: number; lng: number };
    };
    dailyObservations: {
        [key: string]: {
            symptoms: "Normal" | "Aggressive" | "Hypersalivation" | "Paralysis";
            photoURL?: string;
            notes: string;
            date: Date;
        };
    };
    finalStatus: "Released" | "Euthanized" | "Tested Positive";
    relatedBiteCaseId?: string;
}

const QuarantineTracker: React.FC = () => {
    const [selectedDay, setSelectedDay] = useState(1);

    return (
        <div className="space-y-6">
            {/* 10-Day Calendar View */}
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center space-x-2">
                        <Calendar className="h-5 w-5" />
                        <span>10-Day Observation Calendar</span>
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <QuarantineCalendar
                        startDate={quarantine.quarantineStartDate}
                        observations={quarantine.dailyObservations}
                        onDaySelect={setSelectedDay}
                    />
                </CardContent>
            </Card>

            {/* Daily Observation Form */}
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center space-x-2">
                        <Eye className="h-5 w-5" />
                        <span>Day {selectedDay} Observation</span>
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <DailyObservationForm
                        day={selectedDay}
                        observation={
                            quarantine.dailyObservations[`day${selectedDay}`]
                        }
                        onSubmit={handleObservationSubmit}
                    />
                </CardContent>
            </Card>

            {/* Status Timeline */}
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center space-x-2">
                        <FileText className="h-5 w-5" />
                        <span>Observation Timeline</span>
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <QuarantineTimeline
                        observations={quarantine.dailyObservations}
                    />
                </CardContent>
            </Card>
        </div>
    );
};
```

---

## 📈 **Reports & Analytics**

### **Automated Monthly Reports**

```typescript
// services/reports/reportScheduler.ts
export class ReportScheduler {
    static async generateMonthlyReport(
        cityId: string,
        month: number,
        year: number
    ) {
        const reportData = await this.collectReportData(cityId, month, year);
        const pdfBuffer = await PDFGenerator.generateMonthlyReport(reportData);

        // Upload to Firebase Storage
        const reportURL = await uploadReport(
            pdfBuffer,
            `monthly-${cityId}-${year}-${month}.pdf`
        );

        // Save report record
        await addDoc(collection(db, "reports"), {
            reportType: "Monthly",
            generatedFor: "Municipal",
            dateRange: {
                startDate: new Date(year, month - 1, 1),
                endDate: new Date(year, month, 0),
            },
            city: cityId,
            data: reportData,
            reportURL,
            generatedAt: new Date(),
            status: "Generated",
        });

        // Send email notification
        await this.sendReportNotification(reportURL, cityId);
    }

    private static async collectReportData(
        cityId: string,
        month: number,
        year: number
    ) {
        const startDate = new Date(year, month - 1, 1);
        const endDate = new Date(year, month, 0);

        const [
            sterilizations,
            vaccinations,
            biteCases,
            rabiesCases,
            educationEvents,
        ] = await Promise.all([
            getRecordsByDateRange("sterilizations", startDate, endDate, cityId),
            getRecordsByDateRange(
                "vaccination_tracker",
                startDate,
                endDate,
                cityId
            ),
            getRecordsByDateRange("biteCases", startDate, endDate, cityId),
            getRecordsByDateRange("rabiesCases", startDate, endDate, cityId),
            getRecordsByDateRange(
                "educationCampaigns",
                startDate,
                endDate,
                cityId
            ),
        ]);

        return {
            sterilizations: sterilizations.length,
            vaccinations: vaccinations.length,
            biteCases: biteCases.length,
            rabiesCases: rabiesCases.length,
            educationInitiatives: educationEvents.length,
            detailedData: {
                sterilizations,
                vaccinations,
                biteCases,
                rabiesCases,
                educationEvents,
            },
        };
    }
}
```

### **Custom Dashboard for Different Cities**

```typescript
// components/dashboard/CityDashboard.tsx
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

const CityDashboard: React.FC<{ cityId: string }> = ({ cityId }) => {
    const { data: cityData } = useGetCityDataQuery(cityId);
    const { data: wardStats } = useGetWardStatsQuery(cityId);

    return (
        <div className="container mx-auto px-4 py-6 space-y-6">
            {/* City Overview */}
            <CityHeader city={cityData} />

            {/* Ward Performance Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {wardStats?.map((ward) => (
                    <Card
                        key={ward.id}
                        className="cursor-pointer hover:shadow-lg transition-shadow"
                        onClick={() => navigateToWard(ward.id)}
                    >
                        <CardHeader>
                            <CardTitle className="flex items-center justify-between">
                                <span>{ward.name}</span>
                                <Badge variant="secondary">
                                    {ward.stats.total}
                                </Badge>
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <WardCard ward={ward} stats={ward.stats} />
                        </CardContent>
                    </Card>
                ))}
            </div>

            {/* City-wide Charts */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                    <MonthlyTrendsChart cityId={cityId} />
                </div>
                <div className="lg:col-span-1">
                    <TopPerformingWards cityId={cityId} />
                </div>
            </div>

            {/* Hospital Performance */}
            <HospitalDashboard cityId={cityId} />
        </div>
    );
};
```

---

## 🔄 **Real-time Data Synchronization**

### **Firebase Realtime Updates**

```typescript
// hooks/useRealtime.ts
export const useRealtimeData = <T>(
    collection: string,
    filters?: QueryFilter[]
) => {
    const [data, setData] = useState<T[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        let query = collection(db, collection);

        if (filters) {
            filters.forEach((filter) => {
                query = query.where(
                    filter.field,
                    filter.operator,
                    filter.value
                );
            });
        }

        const unsubscribe = onSnapshot(query, (snapshot) => {
            const documents = snapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            })) as T[];

            setData(documents);
            setLoading(false);
        });

        return () => unsubscribe();
    }, [collection, filters]);

    return { data, loading };
};
```

### **Optimistic Updates**

```typescript
// store/slices/sterilizationSlice.ts
export const sterilizationApi = createApi({
    reducerPath: "sterilizationApi",
    baseQuery: firestoreBaseQuery,
    tagTypes: ["Sterilization"],
    endpoints: (builder) => ({
        updateSterilization: builder.mutation({
            query: ({ id, updates }) => ({
                collection: "sterilizations",
                action: "update",
                id,
                data: updates,
            }),
            // Optimistic update
            onQueryStarted: async (
                { id, updates },
                { dispatch, queryFulfilled }
            ) => {
                const patchResult = dispatch(
                    sterilizationApi.util.updateQueryData(
                        "getSterilizations",
                        undefined,
                        (draft) => {
                            const sterilization = draft.find(
                                (s) => s.id === id
                            );
                            if (sterilization) {
                                Object.assign(sterilization, updates);
                            }
                        }
                    )
                );

                try {
                    await queryFulfilled;
                } catch {
                    patchResult.undo();
                }
            },
            invalidatesTags: ["Sterilization"],
        }),
    }),
});
```

---

## 📱 **Progressive Web App (PWA) Features**

### **Manifest Configuration**

```json
// public/manifest.json
{
    "name": "UAWS Management Dashboard",
    "short_name": "UAWS Dashboard",
    "description": "Universal Animal Welfare Society Management System",
    "start_url": "/",
    "display": "standalone",
    "background_color": "#ffffff",
    "theme_color": "#1976d2",
    "icons": [
        {
            "src": "/icons/icon-192x192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "/icons/icon-512x512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ],
    "categories": ["productivity", "utilities"],
    "lang": "en-US"
}
```

### **Service Worker for Offline Support**

```typescript
// public/sw.js
const CACHE_NAME = "uaws-dashboard-v1";
const urlsToCache = [
    "/",
    "/dashboard",
    "/static/js/bundle.js",
    "/static/css/main.css",
];

self.addEventListener("install", (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => cache.addAll(urlsToCache))
    );
});

self.addEventListener("fetch", (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            // Return cached version or fetch from network
            return response || fetch(event.request);
        })
    );
});
```

---

## 🧪 **Testing Strategy**

### **Testing Stack**

```json
{
    "devDependencies": {
        "@testing-library/react": "^13.4.0",
        "@testing-library/jest-dom": "^5.16.5",
        "@testing-library/user-event": "^14.4.3",
        "jest": "^29.7.0",
        "jest-environment-jsdom": "^29.7.0",
        "cypress": "^13.3.0",
        "@types/jest": "^29.5.5"
    }
}
```

### **Component Testing**

```typescript
// __tests__/components/SterilizationForm.test.tsx
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { SterilizationForm } from "@/components/sterilization/SterilizationForm";

describe("SterilizationForm", () => {
    it("validates required fields", async () => {
        render(<SterilizationForm />);

        const submitButton = screen.getByRole("button", { name: /submit/i });
        fireEvent.click(submitButton);

        await waitFor(() => {
            expect(screen.getByText("Species is required")).toBeInTheDocument();
            expect(screen.getByText("Photo is mandatory")).toBeInTheDocument();
        });
    });

    it("submits form with valid data", async () => {
        const mockSubmit = jest.fn();
        render(<SterilizationForm onSubmit={mockSubmit} />);

        // Fill form fields
        fireEvent.change(screen.getByLabelText("Species"), {
            target: { value: "Dog" },
        });
        fireEvent.change(screen.getByLabelText("Sex"), {
            target: { value: "Male" },
        });
        // ... more form fields

        fireEvent.click(screen.getByRole("button", { name: /submit/i }));

        await waitFor(() => {
            expect(mockSubmit).toHaveBeenCalledWith(
                expect.objectContaining({
                    species: "Dog",
                    sex: "Male",
                })
            );
        });
    });
});
```

### **E2E Testing with Cypress**

```typescript
// cypress/e2e/sterilization-flow.cy.ts
describe("Sterilization Workflow", () => {
    beforeEach(() => {
        cy.login("supervisor@uaws.org", "password123");
        cy.visit("/sterilization");
    });

    it("completes full sterilization workflow", () => {
        // Create pickup entry
        cy.get("[data-testid=add-sterilization-btn]").click();
        cy.fillSterilizationForm({
            species: "Dog",
            sex: "Male",
            ageGroup: "Adult",
            ward: "Ward 1",
            tagNumber: "DOG001",
        });
        cy.uploadPhoto("test-dog.jpg");
        cy.get("[data-testid=submit-btn]").click();

        // Verify pickup stage completed
        cy.contains("Pickup stage completed").should("be.visible");

        // Complete operation stage
        cy.get("[data-testid=operation-tab]").click();
        cy.selectOption("[data-testid=operation-status]", "Operated");
        cy.selectDate("[data-testid=operation-date]", "2023-10-15");
        cy.selectOption("[data-testid=surgeon]", "Dr. Smith");
        cy.get("[data-testid=submit-operation]").click();

        // Complete release stage
        cy.get("[data-testid=release-tab]").click();
        cy.selectDate("[data-testid=release-date]", "2023-10-17");
        cy.selectOption("[data-testid=release-status]", "Released");
        cy.get("[data-testid=submit-release]").click();

        // Verify completion
        cy.contains("Sterilization completed successfully").should(
            "be.visible"
        );
    });
});
```

---

## 🚀 **Deployment & Performance**

### **Next.js Configuration**

```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
    experimental: {
        appDir: true,
    },
    images: {
        domains: ["firebasestorage.googleapis.com"],
        formats: ["image/webp", "image/avif"],
    },
    compress: true,
    swcMinify: true,
    compiler: {
        removeConsole: process.env.NODE_ENV === "production",
    },
    webpack: (config, { dev, isServer }) => {
        // Bundle analyzer
        if (!dev && !isServer) {
            config.plugins.push(
                new (require("webpack-bundle-analyzer").BundleAnalyzerPlugin)({
                    analyzerMode: "static",
                    openAnalyzer: false,
                })
            );
        }
        return config;
    },
    // PWA configuration
    pwa: {
        dest: "public",
        register: true,
        skipWaiting: true,
        runtimeCaching: [
            {
                urlPattern: /^https:\/\/firestore\.googleapis\.com\/.*/i,
                handler: "NetworkFirst",
                options: {
                    cacheName: "firestore-cache",
                    expiration: {
                        maxEntries: 32,
                        maxAgeSeconds: 24 * 60 * 60, // 24 hours
                    },
                },
            },
        ],
    },
};

module.exports = nextConfig;
```

### **Performance Optimizations**

```typescript
// Lazy loading components
import dynamic from "next/dynamic";
import { Skeleton } from "@/components/ui/skeleton";

const LazyDashboard = dynamic(() => import("@/components/dashboard/Overview"), {
    loading: () => <Skeleton className="w-full h-96" />,
    ssr: false,
});

// Image optimization
import Image from "next/image";

const OptimizedImage: React.FC = () => (
    <Image
        src="/animal-photo.jpg"
        alt="Animal photo"
        width={400}
        height={300}
        placeholder="blur"
        blurDataURL="data:image/jpeg;base64,..."
        priority={false}
        className="rounded-lg object-cover"
    />
);

// Server Components for data fetching
async function getServerSideProps() {
    return {
        props: {
            // Server-side data loading
        },
    };
}
```

---

## 📋 **Development Timeline**

### **Phase 1 - Core Infrastructure (8 weeks)**

-   Authentication & authorization system
-   Basic dashboard layout
-   Sterilization tracker (3-stage process)
-   User management (Layer 3)
-   Database integration

### **Phase 2 - Additional Modules (6 weeks)**

-   Vaccination tracker
-   Bite case tracker
-   Quarantine tracker (10-day observation)
-   Rabies case surveillance
-   Education initiative tracker

### **Phase 3 - Advanced Features (4 weeks)**

-   City/ward dashboards
-   Report generation system
-   Data export/import tools
-   Real-time notifications
-   Mobile responsive design

### **Phase 4 - Reports & Analytics (3 weeks)**

-   Automated monthly reports
-   Custom dashboard analytics
-   PDF/Excel export functionality
-   Email notification system
-   Audit logging

### **Phase 5 - Testing & Deployment (3 weeks)**

-   Comprehensive testing (unit, integration, E2E)
-   Performance optimization
-   Security audit
-   PWA implementation
-   Production deployment

**Total Development Time: 24 weeks**

---

This web dashboard specification provides a comprehensive management system that covers all UAWS requirements with role-based access, real-time data synchronization, automated reporting, and a scalable architecture suitable for multiple cities and thousands of users.
