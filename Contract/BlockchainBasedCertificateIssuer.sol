// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateIssuer {
    
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Certificate {
        string studentName;
        string courseName;
        string issuedDate;
        bool isValid;
    }

    mapping (uint256 => Certificate) public certificates;

    event CertificateIssued(uint256 certId, string studentName, string courseName);
    event CertificateRevoked(uint256 certId);

    // Only owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    // 1️⃣ Issue Certificate
    function issueCertificate(
        uint256 certId, 
        string memory studentName, 
        string memory courseName, 
        string memory issuedDate
    ) public onlyOwner {
        certificates[certId] = Certificate(studentName, courseName, issuedDate, true);
        emit CertificateIssued(certId, studentName, courseName);
    }

    // 2️⃣ Verify Certificate
    function verifyCertificate(uint256 certId) public view returns (bool) {
        return certificates[certId].isValid;
    }

    // 3️⃣ Get Certificate Details
    function getCertificateDetails(uint256 certId) public view returns (
        string memory studentName,
        string memory courseName,
        string memory issuedDate,
        bool isValid
    ) {
        Certificate memory cert = certificates[certId];
        return (cert.studentName, cert.courseName, cert.issuedDate, cert.isValid);
    }

    // Optional: Revoke Certificate
    function revokeCertificate(uint256 certId) public onlyOwner {
        certificates[certId].isValid = false;
        emit CertificateRevoked(certId);
    }
}

