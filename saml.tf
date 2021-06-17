resource "aws_iam_saml_provider" "default" {
    name = "saml-terratorm"
    saml_metdata_document = file("metadata.xml") 
} 

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRoleWithSAML"] 
        principals {
             type = "Federated" 
             identifiers = ["${aws_iam_saml_provider.default.arn}"]
        } 
        condition {
            test = "Null"
            values = [ 
                "false"
            ] 
            variable = "saml:edupersonentitlement" 
        }
        condition {
            test = "ForAllValues:StringLike" 
            values = [
                "data-users"
            ] 
            variable = "seml:edupersonentitlement"
        }
    }
}

resource "aws_iam_role" "role" {
    name = "saml-sso-role"
    assuse_role_policy = data.aws_iam_policy_document.assume_role_policy.json 
    depends_on = [
        aws_iam_saml_provider.default,
    ]
} 
data "aws_iam_policy_document" "iam_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        resources = [
            "${aws_iam_role.role.arn}"
        ]
    }
}

resource "aws_iam_role_policy" "admin" {
    name = "self-assume-role" 
    role = "${aws_iam_role.role.id}"
    policy = data.aws_iam_policy_document.iam_role_policy.json 
    depends_on = [
        aws_iam_role.role,
    ] 
}

resource "aws_iam_role_policy_attachment" "attach" {
    role = "${aws_iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    depends_on = [
      aws_iam_role_policy.admin
    ]
}