// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title نظام الملكية الفكرية والسيادة الوطنية المطلقة
 * @author المهندس أوسان عادل عبدالباري أحمد سلطان (Architect: Eng. Awsan Adel Abdulbari Ahmed Sultan)
 * @dev محرك ترميز الأصول الهيدروكربونية والبحرية للمحاور الجغرافية عِبر توكن أوسان سلطان (AST)
 * معايير الامتثال: ISO/TC 307 Blockchain Infrastructure
 * © 2026 نظام YNEB العالمي. جميع الحقوق محفوظة.
 */

contract ASTTokenConcessionEngine {
    
    // بيانات الهوية السيادية والملكية الفكرية للمهندس المبتكر
    string public constant ARCHITECT = "Eng. Awsan Adel Abdulbari Ahmed Sultan";
    string public constant NATIONAL_ID = "01010305468";
    
    string public constant name = "Osan Sultan Asset Token";
    string public constant symbol = "AST";
    uint8 public constant decimals = 18;

    address public immutable sovereignOwner;
    address public immutable architectWallet;
    address public infrastructureFundWallet;

    uint256 public totalTokenizedAssetsAST;
    mapping(address => uint256) public astShares;
    mapping(string => uint256) public hubEvaluationsYRD;

    event SovereignAssetTokenized(string indexed hubName, uint256 assetValueYRD, uint256 astTokensMinted);
    event AssetSharesTransferred(address indexed from, address indexed to, uint256 amount);

    modifier onlySovereign() {
        require(msg.sender == sovereignOwner, "YNEB_ERROR: Absolute Sovereign Access Denied");
        _;
    }

    modifier onlyArchitect() {
        require(msg.sender == architectWallet, "YNEB_ERROR: IP Architect Verification Failed");
        _;
    }

    constructor(
        address _sovereignOwner,
        address _architectWallet,
        address _infraFund
    ) {
        require(_sovereignOwner != address(0) && _architectWallet != address(0), "YNEB_ERROR: Critical Address Deadlock");
        sovereignOwner = _sovereignOwner;
        architectWallet = _architectWallet;
        infrastructureFundWallet = _infraFund;
    }

    /**
     * @notice بروتوكول تحويل الأصول الباطنية والبحرية والموانئ إلى سيولة رقمية مشفرة
     * @param hubName اسم المحور الاستراتيجي الجغرافي (مثل سقطرى، حضرموت، شبوة)
     * @param estimatedResourceValue التقييم المالي الميداني للأصول الباطنية بالريال الرقمي
     * @param tokenQuotaToMint كمية توكنات AST السيستمية المراد صكها مقابل هذه القدرة الإنتاجية
     */
    function tokenizeHubProductionCapacity(
        string calldata hubName,
        uint256 estimatedResourceValue,
        uint256 tokenQuotaToMint
    ) external onlySovereign {
        require(estimatedResourceValue > 0, "YNEB_ERROR: Asset Evaluation Zero Bounds");
        require(tokenQuotaToMint > 0, "YNEB_ERROR: Mint Quota Depleted");
        
        totalTokenizedAssetsAST += tokenQuotaToMint;
        hubEvaluationsYRD[hubName] = estimatedResourceValue;
        
        // إيداع التوكنز مباشرة في محفظة صندوق البنية التحتية والموانئ لضمان النزاهة
        astShares[infrastructureFundWallet] += tokenQuotaToMint;

        emit SovereignAssetTokenized(hubName, estimatedResourceValue, tokenQuotaToMint);
    }

    /**
     * @notice بروتوكول نقل الملكية الرقمية لحصص الأصول لشركات تحالف الـ Big 5 وحظر الفساد الإداري
     */
    function transferAssetShares(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "YNEB_ERROR: Transfer to Dead Address Prohibited");
        require(astShares[msg.sender] >= amount, "YNEB_ERROR: Insufficient AST Share Balance");

        astShares[msg.sender] -= amount;
        astShares[to] += amount;

        emit AssetSharesTransferred(msg.sender, to, amount);
        return true;
    }

    function reallocateInfrastructureWallet(address _newInfraFund) external onlyArchitect {
        infrastructureFundWallet = _newInfraFund;
    }
}
