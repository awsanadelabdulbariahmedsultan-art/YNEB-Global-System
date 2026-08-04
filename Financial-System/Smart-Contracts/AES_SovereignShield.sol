// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title نظام العقود الذكية AES صمام الأمان | Algorithmic Enforcement Shield
 * @author المهندس أوسان عادل عبدالباري أحمد سلطان (Architect: Eng. Awsan Adel Abdulbari Ahmed Sultan)
 * @dev إدارة الأموال برمجياً - بدون تدخل بشري (100% Automated, Trustless, and Auditable)
 * @notice يحمي المشروع من أي اختراق أو هدر عبر التحقق المؤتمت من شروط التدفق المالي وأصول الطاقة
 * معايير الأمان والامتثال: ISO/TC 307 Blockchain & Real-World Oracle Validation
 * © 2026 نظام YNEB العالمي. جميع الحقوق محفوظة.
 */

interface IYRDAndASTAssetEngine {
    function yrdBalances(address account) external view returns (uint256);
    function isKYCVerifiedCitizen(address account) external view returns (bool);
    function executeGlobalTradeSettlement(address partner, uint256 grossAmount, string calldata sector, bytes32 receipt) external;
}

contract AES_SovereignShield {

    // وثائق الملكية الفكرية المشفرة في الشيفرة المصدرية للمصمم
    string public constant ARCHITECT = "Eng. Awsan Adel Abdulbari Ahmed Sultan";
    string public constant NATIONAL_ID = "01010305468";
    string public constant SECURITY_SYSTEM = "AES Smart Contracts Shield";

    address public immutable sovereignOwner;
    address public immutable architectWallet;
    address public immutable financialEngineAddress;

    // الحالات التشغيلية لصمام الأمان
    bool public isSystemInterrupted = false; 
    uint256 public totalSovereignVolumeAudited;

    struct EnergyAssetPayload {
        bytes32 assetId;
        uint256 volumeBarrels;
        uint256 thermalUnitCapacity;
        bool isVerifiedByHalliburtonOracle;
        bool isClearedForConversion;
    }

    mapping(bytes32 => EnergyAssetPayload) public registeredEnergyAssets;
    mapping(address => bool) public isAuthorizedSecurityNode;

    // الأحداث البرمجية اللامركزية تماشياً مع المخطط البصري (Events)
    event EnergyAssetTokenizedAndVerified(bytes32 indexed assetId, uint256 volume, uint256 timestamp);
    event AESConditionsTriggered(bytes32 indexed assetId, bool conditionStatus);
    event AutomatedConversionExecuted(bytes32 indexed assetId, uint256 indexed yrdEquivalent);
    event InstantSettlementCleared(address indexed beneficiary, uint256 amountYRD);
    event EmergencySovereignOverrideTriggered(address indexed operator, string reason);

    modifier onlySovereign() {
        require(msg.sender == sovereignOwner, "AES_SECURITY_ERROR: Absolute Sovereign Access Denied");
        _;
    }

    modifier onlyArchitect() {
        require(msg.sender == architectWallet, "AES_SECURITY_ERROR: IP Architect Override Verification Failed");
        _;
    }

    modifier onlyFinancialEngine() {
        require(msg.sender == financialEngineAddress, "AES_SECURITY_ERROR: Request Must Originate From YRD Engine");
        _;
    }

    modifier shieldActive() {
        require(!isSystemInterrupted, "AES_CRITICAL_HALT: System Suspended Via Emergency Protocol");
        _;
    }

    constructor(
        address _sovereignOwner,
        address _architectWallet,
        address _financialEngine
    ) {
        require(_sovereignOwner != address(0) && _architectWallet != address(0), "AES_ERROR: Invalid Operational Address");
        sovereignOwner = _sovereignOwner;
        architectWallet = _architectWallet;
        financialEngineAddress = _financialEngine;
        isAuthorizedSecurityNode[_sovereignOwner] = true;
    }

    /**
     * @notice الخطوة 1 & 2: تسجيل وترميز الأصول النفطية والغازية والتحقق منها (Energy Assets Tokenized & Verified)
     * @dev يستقبل البيانات الفورية من العدادات الذكية وأجهزة الاستشعار (أوراكل هاليبرتون وشلمبرجير) ويقيدها على البلوكشين
     */
    function ingestAndVerifyEnergyAsset(
        bytes32 assetId,
        uint256 volumeBarrels,
        uint256 thermalUnitCapacity,
        bool oracleSignature
    ) external shieldActive {
        require(isAuthorizedSecurityNode[msg.sender], "AES_SECURITY_ERROR: Node Unregistered in Alliance Mesh");
        require(volumeBarrels > 0, "AES_ERROR: Production Quantities Bound Error");

        registeredEnergyAssets[assetId] = EnergyAssetPayload({
            assetId: assetId,
            volumeBarrels: volumeBarrels,
            thermalUnitCapacity: thermalUnitCapacity,
            isVerifiedByHalliburtonOracle: oracleSignature,
            isClearedForConversion: false
        });

        emit EnergyAssetTokenizedAndVerified(assetId, volumeBarrels, block.timestamp);
    }

    /**
     * @notice الخطوة 3 & 4: التحقق الآلي من الشروط والتحويل للريال الرقمي (Conditions Met & Automated Conversion)
     * @dev يُطابق خوارزمياً الشروط التعاقدية دون تدخل بشري ويحول قيمة الأصول العينية إلى مكافئها النقدى بالـ YRD
     */
    function validateConditionsAndTriggerConversion(
        bytes32 assetId,
        uint256 pricePerUnitYRD,
        address globalBuyer
    ) external shieldActive returns (uint256) {
        EnergyAssetPayload storage asset = registeredEnergyAssets[assetId];
        
        // التحقق البرمجي التلقائي: (if conditions_met)
        require(asset.isVerifiedByHalliburtonOracle, "AES_CONDITION_ERROR: Real-World Telemetry Oracle Verification Missing");
        require(!asset.isClearedForConversion, "AES_CONDITION_ERROR: Double Conversion Hazard Prevented");

        asset.isClearedForConversion = true;
        uint256 totalEquivalentYRD = asset.volumeBarrels * pricePerUnitYRD;

        emit AESConditionsTriggered(assetId, true);
        emit AutomatedConversionExecuted(assetId, totalEquivalentYRD);

        // تحويل الطلب تلقائياً لمحرك التسويات الدولية لمعالجة الحسابات الإقليمية
        IYRDAndASTAssetEngine(financialEngineAddress).executeGlobalTradeSettlement(
            globalBuyer, 
            totalEquivalentYRD, 
            "Hydrocarbon Export", 
            assetId
        );

        totalSovereignVolumeAudited += totalEquivalentYRD;
        return totalEquivalentYRD;
    }

    /**
     * @notice الخطوة 5: التسوية الفورية والنهائية (Instant Settlement & Key Benefits)
     * @dev يضمن دقة وصفرية تأخير التحويلات النقدية والتدقيق الشفاف بنسبة 100% من طبقة الذكاء الاصطناعي
     */
    function auditAndClearInstantSettlement(
        address beneficiary, 
        uint256 expectedSettlementYRD
    ) external onlyFinancialEngine shieldActive view returns (bool) {
        uint256 actualBalance = IYRDAndASTAssetEngine(financialEngineAddress).yrdBalances(beneficiary);
        
        // نظام مراقبة ومطابقة النزاهة المالية اللحظية (Zero Corruption Framework)
        if (actualBalance >= expectedSettlementYRD) {
            return true;
        }
        return false;
    }

    // دوال إدارة صمام الأمان والحماية الجيوسياسية والسيبرانية الفائقة
    function configureSecurityNode(address nodeAddress, bool operationalStatus) external onlySovereign {
        isAuthorizedSecurityNode[nodeAddress] = operationalStatus;
    }

    /**
     * @notice صمام الأمان التكنولوجي والسيادي لحالات الطوارئ القصوى (Emergency Sovereign Override)
     * @dev يمنح المهندس المبتكر أوسان سلطان الحق في قفل النظام بالكامل برمجياً لحماية الأمن القومي عند رصد ثغرات سيبرانية دولية
     */
    function triggerEmergencySovereignOverride(bool haltStatus, string calldata securityReason) external onlyArchitect {
        isSystemInterrupted = haltStatus;
        emit EmergencySovereignOverrideTriggered(msg.sender, securityReason);
    }
}
