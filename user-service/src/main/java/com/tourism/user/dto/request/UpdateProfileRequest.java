package com.tourism.user.dto.request;

import lombok.Data;

@Data
public class UpdateProfileRequest {
    private String firstName;
    private String lastName;
    private String profileImageUrl;
    private String preferredLanguage;
    private String preferredCurrency;
}
