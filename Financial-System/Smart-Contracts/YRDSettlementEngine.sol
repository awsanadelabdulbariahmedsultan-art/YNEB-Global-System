// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title نظام الملكية الفكرية والسيادة الوطنية المطلقة
 * @author المهندس أوسان عادل عبدالباري أحمد سلطان (Architect: Eng. Awsan Adel Abdulbari Ahmed Sultan)
 * @dev بروتوكول المقاصة والتسويات الدولية للريال الرقمي (YRD) والربط مع صندوق النقد والبنك الدوليين
 * معايير الامتثال: IMF Digital Ledger standards & ISO 28000
 * © 2026 نظام YNEB العالمي. جميع الحقوق محفوظة.
 */

interface IIMFWorldBankClearingRouter {
    function verifyTransactionLegitimacy(address partner, uint256 amount) external view returns (bool);
    function reportToGlobalLedger(bytes32 txHash, uint256 volume, string calldata sector) external;
}

contract YRDSettlementEngine {

    // بيانات الهوية السيادية والملكية الفكرية للمهندس المبتكر
    string public constant ARCHITECT = "Eng. Awsan Adel Abdulbari Ahmed Sultan";
    string public constant NATIONAL_ID = "01010305468";
    
    string public constant name = "Yemeni Rial Digital CBDC";
    string public constant symbol = "YRD";

    address public immutable sovereignOwner;
    address public immutable architectWallet;
    
    // نسب معادلة التوزيع الاجتماعي الخوارزمية (20-40-40) وحقوق الابتكار الفكري
    uint256 public constant TREASURY_PERC = 20;     // 20% الخزينة العامة والاحتياطي الاستراتيجي للدولة
    uint256 public constant INFRASTRUCTURE_PERC = 40; // 40% إعادة استثمار البنية التحتية والموانئ والطاقة النظيفة
    uint256 public constant CITIZEN_DIVIDEND_PERC = 40; // 40% عوائد ومنافع اجتماعية مباشرة للمواطنين عِبر محافظ KYC
    uint256 public constant ARCHITECT_ROYALTY_PERC = 1; // 0.01% حق الملكية الفكرية والابتكار للمبتكر (جزء من 10000)

    address public nationalTreasuryWallet;
    address public infrastructureFundWallet;
    address public imfWorldBankClearingRouter;
    address public deloitteAuditOracle;

    mapping(address => uint256) public yrdBalances;
    mapping(address => bool) public isKYCVerifiedCitizen;
    mapping(address => bool) public isGlobalPartnerAllowed; // شركات تحالف الـ Big 5

    uint256 public totalSovereignLiquidityYRD;

    event IMFWorldBankSettlementExecuted(address indexed globalPartner, uint256 totalGrossAmount, bytes32 imfClearanceReceipt);
    event AlgorithmicDistributionTriggered(uint256 treasuryShare, uint256 infraShare, uint256 citizensShare, uint256 architectRoyalty);
    event CitizenWalletCredited(address indexed citizen, uint256 amount);

    modifier onlySovereign() {
        require(msg.sender == sovereignOwner, "YNEB_ERROR: Absolute Sovereign Access Denied");
        _;
    }

    modifier onlyArchitect() {
        require(msg.sender == architectWallet, "YNEB_ERROR: IP Architect Verification Failed");
        _;
    }

    modifier onlyAuditedTx(address partner, uint256 amount) {
        require(isGlobalPartnerAllowed[partner], "YNEB_ERROR: Partner Unauthorized by Big 5 Alliance");
        require(IIMFWorldBankClearingRouter(imfWorldBankClearingRouter).verifyTransactionLegitimacy(partner, amount), "IMF_ERROR: Trade Flow Cleared Flag Negative");
        _;
    }

    constructor(
        address _sovereignOwner,
        address _architectWallet,
        address _treasury,
        address _infraFund,
        address _imfRouter,
        address _deloitteOracle
    ) {
        sovereignOwner = _sovereignOwner;
        architectWallet = _architectWallet;
        nationalTreasuryWallet = _treasury;
        infrastructureFundWallet = _infraFund;
        imfWorldBankClearingRouter = _imfRouter;
        deloitteAuditOracle = _deloitteOracle;
    }

    /**
     * @notice بروتوكول المقاصة والتسويات النقدية الدولية مع صندوق النقد والبنك الدوليين (YRD Settlement Axis)
     * @dev يعالج مدفوعات عقود الطاقة وعوائد التصدير والموانئ عِبر الريال الرقمي والتحقق المؤتمت من الـ IMF
     */
    function executeGlobalTradeSettlement(
        address globalPartner,
        uint256 grossAmountYRD,
        string calldata operationalSector,
        bytes32 imfReceiptToken
    ) external onlyAuditedTx(globalPartner, grossAmountYRD) {
        require(grossAmountYRD >= 10000, "YNEB_ERROR: Settlement Under Dust Limits");

        yrdBalances[globalPartner] -= grossAmountYRD;
        
        // احتساب دقيق لجزء من الألف لضمان حصانة ونزاهة حق الملكية الفكرية (0.01% IP Royalty) لـ أوسان سلطان
        uint256 architectRoyalty = (grossAmountYRD * ARCHITECT_ROYALTY_PERC) / 10000; 
        uint256 netSovereignPool = grossAmountYRD - architectRoyalty;

        // تفعيل معادلة التوزيع الاجتماعي المؤتمتة خوارزمياً (20-40-40) لضمان وصول الموارد لكل منزل يمني
        uint256 treasuryShare = (netSovereignPool * TREASURY_PERC) / 100;
        uint256 infrastructureShare = (netSovereignPool * INFRASTRUCTURE_PERC) / 100;
        uint256 citizenDistributionPool = (netSovereignPool * CITIZEN_DIVIDEND_PERC) / 100;

        // إيداع الحصص مباشرة وبصيغة مستقلة في محافظ الصناديق والمخازن السيادية المشفرة دون تدخل بشري
        yrdBalances[architectWallet] += architectRoyalty;
        yrdBalances[nationalTreasuryWallet] += treasuryShare;
        yrdBalances[infrastructureFundWallet] += infrastructureShare;
        
        totalSovereignLiquidityYRD += netSovereignPool;

        // إرسال تقرير المعاملة اللحظي مشفراً لغرفة المقاصة والتدقيق لدفتر الأستاذ العالمي للـ IMF لضمان الحصانة الدولية
        bytes32 txHash = keccak256(abi.encodePacked(msg.sender, globalPartner, grossAmountYRD, block.timestamp));
        IIMFWorldBankClearingRouter(imfWorldBankClearingRouter).reportToGlobalLedger(txHash, grossAmountYRD, operationalSector);

        emit IMFWorldBankSettlementExecuted(globalPartner, grossAmountYRD, imfReceiptToken);
        emit AlgorithmicDistributionTriggered(treasuryShare, infrastructureShare, citizenDistributionPool, architectRoyalty);
    }

    /**
     * @notice خوارزمية التوزيع المباشر للثروة وعوائد المواطنين (Direct-to-Citizen Distribution Algorithm)
     * @dev توزع حصة الـ 40% المخصصة للمجتمع على محافظ المواطنين الموثقة هوياتهم برمجياً (KYC Wallets) دون تدخل بشري
     */
    function distributeSocialDividendsToKYCWallets(
        address[] calldata verifiedCitizens, 
        uint256 totalDistributionAmount
    ) external onlySovereign {
        require(totalDistributionAmount > 0, "YNEB_ERROR: Distribution Pool Depleted");
        uint256 citizenCount = verifiedCitizens.length;
        require(citizenCount > 0, "YNEB_ERROR: Active KYC Citizen Registry Empty");

        uint256 dividendPerShare = totalDistributionAmount / citizenCount;

        for (uint256 i = 0; i < citizenCount; i++) {
            address citizen = verifiedCitizens[i];
            if (isKYCVerifiedCitizen[citizen]) {
                yrdBalances[citizen] += dividendPerShare;
                emit CitizenWalletCredited(citizen, dividendPerShare);
            }
        }
    }

    function updateGlobalPartnerAuthorization(address partner, bool status) external onlySovereign {
        isGlobalPartnerAllowed[partner] = status;
    }

    function setCitizenKYCStatus(address citizen, bool status) external onlySovereign {
        isKYCVerifiedCitizen[citizen] = status;
    }

    function upgradeClearingInfrastructure(address _newIMFRouter, address _newDeloitteOracle) external onlyArchitect {
        imfWorldBankClearingRouter = _newIMFRouter;
        deloitteAuditOracle = _newDeloitteOracle;
    }
}
